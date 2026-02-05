#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"

build_xcode() {
	title "Building XCode"

	if ! xcode-select --print-path &>/dev/null; then
		xcode-select --install &>/dev/null

		until xcode-select --print-path &>/dev/null; do
			sleep 5
		done
	fi

	sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
	sudo xcodebuild -license accept
}

if build_xcode; then
	ok "XCode built successfully!"
else
	err_exit "Building XCode failed."
fi
