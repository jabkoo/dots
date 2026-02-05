#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"

failed=0
(
	title "Creating custom directories"

	dirs=(
		"$HOME/Repos/selfhosted"
		"$HOME/Repos/jabkoo"
		"$HOME/.config"
		"$HOME/.ssh"
	)

	for dir in "${dirs[@]}"; do
		info "Creating a new directory at $dir"
        mkdir -p "$dir"
    done

	ln -sf "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/Cloud"
	ln -sf "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents" "$HOME/Obsidian"
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Custom directories created successfully!"
else'/Users/jabko/Library/Mobile Documents/iCloud~md~obsidian/Documents'
	err_exit "One or more errors occured during creating custom directories. Try running dirs.sh again."
fi
