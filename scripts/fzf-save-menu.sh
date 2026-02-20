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

	local dir="$(snapshot_dir)"
	local snapshots="$(get_snapshots)"
	local result

	if [ -n "$snapshots" ]; then
		result="$(echo "$snapshots" | fzf \
			--reverse \
			--print-query \
			--header="Save snapshot (Enter: save, Esc: cancel)" \
			--bind "change:reload(find '$dir' -maxdepth 1 -type l -printf '%f\n' 2>/dev/null | sort)" \
			--query="" \
			--no-clear)"
	else
		result="$(fzf \
			--reverse \
			--print-query \
			--header="Enter snapshot name (Enter: save, Esc: cancel)" \
			--bind "change:reload(find '$dir' -maxdepth 1 -type l -printf '%f\n' 2>/dev/null | sort)" \
			--query="" \
			--no-clear)"
	fi

	local query="$(echo "$result" | head -1)"
	local selected="$(echo "$result" | tail -1)"

	if [ -n "$query" ]; then
		"$CURRENT_DIR/save-snapshot.sh" "$query"
	elif [ -n "$selected" ]; then
		"$CURRENT_DIR/save-snapshot.sh" "$selected"
	fi
}

main
