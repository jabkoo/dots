#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Stowing packages"

	stow -d $DOTFILES -t $HOME git ssh zsh ghostty nvim mise
) || failed=1

if [ $failed -eq 0 ]; then
	ok "All packages stowed successfully!"
else
	err_exit "One or more errors occured during stow. Try running stow.sh again."
fi
