#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "$DIR/../utils.sh"

update_mac() {
	title "Updating MacOS software"

	softwareupdate --install --all --force --agree-to-license

	if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1
  	then
	    info "Installing Rosetta"
		softwareupdate --install-rosetta --agree-to-license
	else
		info "Rosetta is already installed"
	fi

 	if ! xcode-select --print-path &>/dev/null; then
		xcode-select --install &>/dev/null

		until xcode-select --print-path &>/dev/null; do
			sleep 5
		done
	fi
	sudo xcode-select -s /Library/Developer/CommandLineTools
}

if update_mac; then
	ok "Finished software update successfully"
else
	err_exit "Updating MacOS failed."
fi
