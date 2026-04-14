package main

import "./cli"
import "./common"
import "./update"
import "base:runtime"
import "core:log"
import "core:os"
import "core:strings"

get_player_name :: proc() -> string {
	when ODIN_OS == .Windows {
		return "sucata-player.exe"
	}
	return "sucata-player"
}

get_player_version :: proc() -> string {
	state, stdout, stderr, err := os.process_exec(
		os.Process_Desc{command = {get_player_name(), "--version"}},
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

main :: proc() {
	context.logger = log.create_console_logger(lowest = .Info)
	defer log.destroy_console_logger(context.logger)

	cli.version = get_player_version()
	defer delete(cli.version)

	is_old_version := update.check_version(cli.version)
	if is_old_version {
		common.print_warning("A new version is available! Use: 'sucata update' to install")
	}

	cli.main()
}
