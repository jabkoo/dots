#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "$DIR/../utils.sh"
. "$HOME/.zprofile"

stow_packages() {
	title "Stowing packages"

	stow -d $DOTFILES -t $HOME git ssh zsh ghostty nvim mise
}

if stow_packages; then
	ok "All packages stowed successfully!"
else
	err_exit "Stowing packages failed."
fi
