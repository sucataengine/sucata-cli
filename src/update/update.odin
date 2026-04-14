package update

import "core:fmt"
import "core:os"

get_update_command :: proc() -> string {
	when ODIN_OS == .Windows {
		return fmt.tprintf(
			"Start-Sleep -Seconds 3; irm https://codeberg.org/sucata/sucata/raw/branch/main/install_windows.ps1 | iex",
		)
	} else {
		return fmt.tprintf(
			"sleep 3 && curl -fsSL https://codeberg.org/sucata/sucata/raw/branch/main/install_unix.sh | bash",
		)
	}
}

get_shell :: proc() -> (string, string) {
	when ODIN_OS == .Windows {
		return "powershell", "-Command"
	} else {
		return "bash", "-c"
	}
}

update_sucata :: proc() {
	command := get_update_command()

	shell, arg := get_shell()

	process_desc := os.Process_Desc {
		command = {shell, arg, command},
	}

	_, _ = os.process_start(process_desc)
	os.exit(0)
}
