package build

import "../common"
import "base:runtime"
import "core:c"
import "core:mem"
import "core:path/filepath"
import "core:strings"
import stbi "vendor:stb/image"

JPEG_QUALITY :: 85

@(private = "file")
Image_Write_Buffer :: struct {
	data: [dynamic]byte,
}

@(private = "file")
write_to_buffer :: proc "c" (user: rawptr, chunk: rawptr, size: c.int) {
	context = runtime.default_context()
	buf := cast(^Image_Write_Buffer)user
	append(&buf.data, ..mem.byte_slice(chunk, int(size)))
}

@(private = "file")
is_lossless_image_file :: proc(path: string) -> bool {
	ext := filepath.ext(path)
	return(
		strings.equal_fold(ext, ".png") ||
		strings.equal_fold(ext, ".bmp") ||
		strings.equal_fold(ext, ".tga") \
	)
}

compress_image :: proc(rel_path: string, data: []byte) -> (result: []byte, allocated: bool) {
	if !is_lossless_image_file(rel_path) {
		return data, false
	}

	w, h, comp: c.int
	if stbi.info_from_memory(raw_data(data), c.int(len(data)), &w, &h, &comp) == 0 {
		return data, false
	}

	has_alpha := comp == 2 || comp == 4
	if has_alpha {
		return data, false
	}

	pixels := stbi.load_from_memory(raw_data(data), c.int(len(data)), &w, &h, &comp, comp)
	if pixels == nil {
		return data, false
	}
	defer stbi.image_free(pixels)

	write_buf := Image_Write_Buffer {
		data = make([dynamic]byte),
	}

	ok := stbi.write_jpg_to_func(write_to_buffer, &write_buf, w, h, comp, pixels, JPEG_QUALITY)
	if ok == 0 || len(write_buf.data) == 0 || len(write_buf.data) >= len(data) {
		delete(write_buf.data)
		return data, false
	}

	common.print_info(
		"  [image] %s -> jpg (%d bytes -> %d bytes)",
		rel_path,
		len(data),
		len(write_buf.data),
	)

	return write_buf.data[:], true
}
