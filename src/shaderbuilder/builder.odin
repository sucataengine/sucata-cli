package shader_builder

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

build_shader :: proc(input_file: string) -> (string, bool) {
	ok, temp_path := build_sokol_shader(input_file)
	defer delete(temp_path)

	shader_name_dots := strings.split(filepath.base(input_file), ".")
	defer delete(shader_name_dots)
	shader_name := shader_name_dots[0]
	input_dir := filepath.dir(input_file)
	output_file_name := fmt.aprintf("%s.schd", shader_name)
	defer delete(input_dir)
	defer delete(output_file_name)

	output_path, _ := filepath.join({input_dir, output_file_name}, context.allocator)

	if ok {
		generate_json(temp_path, output_path)
		remove_temp_folder(filepath.dir(temp_path))
	}

	return output_path, ok
}

remove_temp_folder :: proc(temp_path: string) {
	if os.exists(temp_path) {
		os.remove_all(temp_path)
	}
}
