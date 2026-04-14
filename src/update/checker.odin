package update

import "core:strings"
import "shared:http/client"

VERSION_URL :: "https://codeberg.org/sucata/sucata/raw/branch/main/VERSION"

get_last_version :: proc() -> (string, bool) {
	res, err := client.get(VERSION_URL)
	if err != nil {
		return strings.clone(""), true
	}
	defer client.response_destroy(&res)

	body, allocation, berr := client.response_body(&res)
	if berr != nil {
		return strings.clone(""), true
	}
	defer client.body_destroy(body, allocation)

	return strings.clone(body.(client.Body_Plain)), false
}

check_version :: proc(current_version: string) -> (string, bool) {
	last_version, err := get_last_version()
	if err {
		return strings.clone(""), false
	}

	return last_version, !strings.equal_fold(current_version, last_version)
}
