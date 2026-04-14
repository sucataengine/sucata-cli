package cli

import "../common"
import "core:os"

ROOT_COMMAND :: Command {
	subcommands = {RUN_COMMAND, BUILD_COMMAND, VERSION_COMMAND, SHADER_COMMAND, UPDATE_COMMAND},
}

main :: proc() {
	welcome_message()

	args := os.args
	parse_cli(ROOT_COMMAND, args[1:])
}

welcome_message :: proc() {
	common.print("Sucata Game Engine - %s", version)
}
