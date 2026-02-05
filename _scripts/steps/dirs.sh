#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "$DIR/../utils.sh"

create_directories() {
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
}

if create_directories; then
	ok "Custom directories created successfully!"
else
	err_exit "Directories creation failed."
fi
