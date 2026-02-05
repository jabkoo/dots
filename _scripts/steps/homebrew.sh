#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "$DIR/../utils.sh"

install_homebrew() {
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
}

if install_homebrew; then
	ok "Homebrew packages were installed successfully!"
else
	err_exit "Installing homebrew packages failed."
fi
