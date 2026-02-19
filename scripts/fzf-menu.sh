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

	local selected="$(echo "$snapshots" | fzf \
		--reverse \
		--header="Select snapshot to restore (Esc to cancel)")"

	if [ -n "$selected" ]; then
		"$CURRENT_DIR/restore-snapshot.sh" "$selected"
	fi
}

main
