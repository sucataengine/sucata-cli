package main

import "./cli"
import "base:runtime"
import "core:log"
import "core:os"
import "core:path/filepath"
import "core:strings"

get_player_name :: proc() -> string {
	when ODIN_OS == .Windows {
		return "sucata-player.exe"
	}
	return "sucata-player"
}

get_player_path :: proc() -> string {
	current_path, _ := os.get_executable_directory(context.allocator)
	defer delete(current_path)
	result, _ := filepath.join({current_path, get_player_name()}, context.allocator)
	return result
}

get_player_version :: proc() -> string {
	player_path := get_player_path()
	defer delete(player_path)
	state, stdout, stderr, err := os.process_exec(
		os.Process_Desc{command = {player_path, "--version"}},
		context.allocator,
	)
	defer delete(stdout)
	defer delete(stderr)

	if err != nil || state.exit_code != 0 {
		return strings.clone("unknown")
	}

	version := strings.trim_right_space(string(stdout))
	return strings.clone(version)
}

//check_new_version :: proc(current_version: string) {
//	is_old_version := update.check_version(current_version)
//	if is_old_version {
//		common.print_warning("A new version is available! Use: 'sucata update' to install")
//	}
//}

main :: proc() {
	context.logger = log.create_console_logger(lowest = .Info)
	defer log.destroy_console_logger(context.logger)

	cli.version = get_player_version()
	defer delete(cli.version)

	//check_new_version(cli.version)

	cli.main()
}
