#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"

failed=0
(
	title "Installing Homebrew packages"

	if ! command -v brew &> /dev/null; then
		info "Homebrew not found. Installing...\n"

		installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh 2>&1)
		exitcode=$?

		if [ $exitcode -ne 0 ] ; then
		    err_exit "Failed to download Homebrew installation script. Error code $exitcode. Please try again."
		fi;

		/bin/bash -c "$installer"

		if ! grep -q -s '/opt/homebrew/bin/brew shellenv' "$HOME/.zprofile"; then
			echo $'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
		fi

		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		info "Homebrew already installed. Updating...\n"
		brew update
	fi

	info "Installing packages from Homebrew..."

	brew bundle --cleanup --file "$DOTFILES/Brewfile"
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Homebrew packages were installed successfully!"
else
	err_exit "One or more errors occured during Homebrew installation. Try running homebrew.sh again."
fi
