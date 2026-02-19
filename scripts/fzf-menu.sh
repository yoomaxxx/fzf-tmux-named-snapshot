#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

get_snapshots() {
	local dir="$(snapshot_dir)"
	if [ -d "$dir" ]; then
		find "$dir" -maxdepth 1 -type l -printf "%f\n" 2>/dev/null | sort
	fi
}

get_delete_key() {
	echo "$(get_tmux_option "$delete_key_option" "$default_delete_key")"
}

main() {
	if ! command -v fzf &>/dev/null; then
		tmux display-message "fzf not found. Please install fzf."
		return 1
	fi

	local snapshots="$(get_snapshots)"

	if [ -z "$snapshots" ]; then
		tmux display-message "No snapshots found"
		return 0
	fi

	local delete_key="$(get_delete_key)"
	local selected="$(echo "$snapshots" | fzf \
		--reverse \
		--header="Select snapshot (Enter: restore, $delete_key: delete, Esc: cancel)" \
		--bind "$delete_key:execute($CURRENT_DIR/delete-snapshot.sh {})+reload($CURRENT_DIR/fzf-menu.sh get_snapshots)")"

	if [ -n "$selected" ]; then
		"$CURRENT_DIR/restore-snapshot.sh" "$selected"
	fi
}

main
