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

get_snapshot_info() {
	local name="$1"
	local dir="$(snapshot_dir)"
	local link_path="$dir/$name"

	if [ -L "$link_path" ]; then
		local target="$(readlink "$link_path")"
		local mtime="$(stat -c "%y" "$target" 2>/dev/null | cut -d'.' -f1)"
		local size="$(stat -c "%s" "$target" 2>/dev/null)"
		echo "Target: $target"
		echo "Modified: $mtime"
		echo "Size: ${size:-0} bytes"
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
		--header="Select snapshot to restore (Esc to cancel)" \
		--preview-window=right:50% \
		--preview="$CURRENT_DIR/fzf-menu.sh preview {}")"

	if [ -n "$selected" ]; then
		"$CURRENT_DIR/restore-snapshot.sh" "$selected"
	fi
}

if [ "$1" = "preview" ]; then
	get_snapshot_info "$2"
else
	main
fi
