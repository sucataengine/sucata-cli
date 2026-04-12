package main

import cli "./cli"
import "base:runtime"
import "core:log"
import "core:os/os2"
import "core:strings"

get_player_name :: proc() -> string {
	when ODIN_OS == .Windows {
		return "sucata-player.exe"
	}
	return "sucata-player"
}

get_player_version :: proc() -> string {
	state, stdout, stderr, err := os2.process_exec(
		os2.Process_Desc{command = {get_player_name(), "--version"}},
		context.allocator,
	)

	if err != nil || state.exit_code != 0 {
		return strings.clone("unknown")
	}

	version := strings.trim_right_space(string(stdout))
	return strings.clone(version)
}

main :: proc() {
	context.logger = log.create_console_logger()
	cli.version = get_player_version()
	defer delete(cli.version)

	cli.main()
}
