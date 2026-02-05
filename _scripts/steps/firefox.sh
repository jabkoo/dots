#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"
source "$HOME/.zprofile"

FF_PROFILE_NAME="jabko"

ff_profile_folder=""

addonlist="ublock-origin istilldontcareaboutcookies violentmonkey addy_io bitwarden-password-manager surfingkeys_ff"

prepare_firefox() {
	info "Setting up Firefox"

    firefox -CreateProfile $FF_PROFILE_NAME
    firefox -no-remote &

    while [ ! -f "$HOME/Library/Application Support/Firefox/installs.ini" ]; do
        sleep 1
    done

    ff_profile_folder=$(find "$HOME/Library/Application Support/Firefox/Profiles" -type d -name "*.$FF_PROFILE_NAME" -exec basename {} \;)
	ff_default_profile_folder=$(find "$HOME/Library/Application Support/Firefox/Profiles" -type d -name "*.default-release" -exec basename {} \;)
	sed -i "" "s/Default=Profiles\/$ff_default_profile_folder/Default=Profiles\/$ff_profile_folder/g" "$HOME/Library/Application Support/Firefox/profiles.ini"
    sed -i "" "s/default-release/$FF_PROFILE_NAME/g" "$HOME/Library/Application Support/Firefox/installs.ini"

    killall "firefox" 2>/dev/null || true

    ln -fnsv "$DOTFILES/firefox/user.js" "$HOME/Library/Application Support/Firefox/Profiles/$ff_profile_folder"

    install_firefox_addons
}

install_firefox_addons() {
	addontmp="$(mktemp -d)"
	profile_dir="$HOME/Library/Application Support/Firefox/Profiles/$ff_profile_folder"
	trap "rm -fr $addontmp" HUP INT QUIT TERM ABRT EXIT
	IFS=' '
	mkdir -p "$profile_dir/extensions/"

	for addon in $addonlist; do
		addonurl="$(curl --silent "https://addons.mozilla.org/en-US/firefox/addon/${addon}/" | grep -o 'https://addons.mozilla.org/firefox/downloads/file/[^"]*')"
		file="${addonurl##*/}"
		tmpfile="$addontmp/$file"
		curl -Ls "$addonurl" -o $tmpfile
		id="$(unzip -p "$tmpfile" manifest.json | grep "\"id\"")"
		id="${id%\"*}"
		id="${id##*\"}"
		mv -n "$tmpfile" "$profile_dir/extensions/$id.xpi"
	done
}

failed=0
(
	title "Setting up Firefox"

	prepare_firefox
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Firefox set up successfully!"
else
	err_exit "One or more errors occured during Firefox setup. Try running firefox.sh again."
fi
