package cli

import "../common"
import "../update"

UPDATE_COMMAND :: Command {
	command = "update",
	args_size = 0,
	info_msg = "sucata update - Update sucata to the lastest version",
	error_msg = "Error: 'update' command.",
	handler = proc(args: []string) {
		common.print("Updating sucata...")
		update.update_sucata()
	},
}
