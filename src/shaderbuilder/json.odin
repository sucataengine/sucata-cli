package shader_builder

import "../common"
import "core:encoding/json"
import "core:os"
import "core:strings"

inject_shader_data :: proc(yaml_data: ^YamlValue) -> ^YamlValue {
	shaders := yaml_data.(map[string]YamlValue)["shaders"].([]YamlValue)

	for shader in shaders {
		program := shader.(map[string]YamlValue)["programs"].([]YamlValue)[0].(map[string]YamlValue)

		vertex_func := program["vertex_func"].(map[string]YamlValue)
		fragment_func := program["fragment_func"].(map[string]YamlValue)

		vertex_path := vertex_func["path"].(string)
		fragment_path := fragment_func["path"].(string)

		vertex_data, vertex_err := os.read_entire_file_from_path(vertex_path, context.allocator)
		fragment_data, fragment_err := os.read_entire_file_from_path(
			fragment_path,
			context.allocator,
		)

		if vertex_err != nil || fragment_err != nil {
			if vertex_err == nil { delete(vertex_data) }
			if fragment_err == nil { delete(fragment_data) }
			common.print_error("Failed to read shader files: %s, %s", vertex_path, fragment_path)
			continue
		}

		vertex_func[strings.clone("data")] = vertex_data
		fragment_func[strings.clone("data")] = fragment_data
		delete_key(&vertex_func, "path")
		delete_key(&fragment_func, "path")
	}

	return yaml_data
}

generate_json :: proc(yaml_path: string, output_path: string) -> (string, bool) {
	data, data_ok := os.read_entire_file_from_path(yaml_path, context.allocator)

	if data_ok != nil {
		common.print_error("Failed to read generated shader file: %s", yaml_path)
		return "", false
	}
	defer delete(data)

	data_string := string(data)
	yaml_data := parse_yaml(data_string)
	yaml_data_with_shader := inject_shader_data(&yaml_data)
	defer free_yaml_value(&yaml_data)

	json_data, json_ok := json.marshal(yaml_data)
	defer delete(json_data)

	if json_ok != json.Marshal_Data_Error.None {
		common.print_error("Failed to convert YAML to JSON for shader: %s", yaml_path)
		return "", false
	}

	_ = os.write_entire_file(output_path, json_data)

	return output_path, true
}
