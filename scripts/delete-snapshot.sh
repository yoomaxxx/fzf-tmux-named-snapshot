#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

main() {
	local name="$1"
	if [ -n "$name" ]; then
		local name_path="$(snapshot_dir)/$name"
		if [[ -L "$name_path" ]]; then
			rm "$name_path"
			tmux display-message "Snapshot '$name' deleted"
		else
			tmux display-message "Snapshot '$name' not found"
		fi
	fi
}

main "$@"
