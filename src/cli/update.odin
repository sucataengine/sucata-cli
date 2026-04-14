package cli

import "../common"
import "../update"

UPDATE_COMMAND :: Command {
	command = "update",
	args_size = 0,
	info_msg = "sucata update - Update sucata to the lastest version",
	error_msg = "Error: 'update' command.",
	handler = proc(args: []string) {
		if update.check_version(version) {
			common.print("Updating sucata...")
			update.update_sucata()
		} else {
			common.print_success("Sucata is already in the last version!")
		}
	},
}
