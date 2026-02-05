#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"

failed=0
(
	title "Creating custom directories"

	dirs=(
		"$HOME/Projects/selfhosted"
		"$HOME/Projects/jabkoo"
		"$HOME/.config"
		"$HOME/.ssh"
	)

	for dir in "${dirs[@]}"; do
		info "Creating a new directory at $dir"
        mkdir -p "$dir"
    done

	ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/Cloud"
	ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/03_SecondBrain" "$HOME/SecondBrain"
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Custom directories created successfully!"
else
	err_exit "One or more errors occured during creating custom directories. Try running dirs.sh again."
fi
