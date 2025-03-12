#!/bin/sh

set -o posix

source "$DIR/utils.sh"

AVAILABLE_SCRIPTS=(
	"dirs"
	"softwareupdate"
	"homebrew"
	"stow"
	"ssh"
	"firefox"
	"xcode"
	"defaults"
)

scripts_to_run=()

usage() {
	echo "Usage: $0 [OPTIONS]"
	echo "Options (use only one at a time):"
	echo "  -h, --help			Display this help message"
	echo "  -o, --only			Execute only specified scripts"
	echo "  -e, --except		Exclude specified scripts from running"
	echo "Available scripts:"
	echo "  dirs				Creates custom directories"
	echo "  softwareupdate		Runs MacOS software update and installs Rosetta"
	echo "  homebrew			Installs Homebrew package manager and packages defined in Brewfile"
	echo "  stow				Stows packages"
	echo "  ssh					Generates a new SSH key"
	echo "  firefox				Configures Firefox browser"
	echo "  xcode				Builds XCode"
	echo "  defaults            Configures various default MacOS settings"
}

check_and_extract_arguments() {
	flag="$1"
	shift;
	selected_scripts=()

	for element in "$@"; do
		if [[ ! " ${AVAILABLE_SCRIPTS[*]} " =~ $element ]]; then
			err "Invalid argument: $element" >&2
			usage
			exit 1
		else
			selected_scripts+=("$element")
		fi
	done

	if [ "$flag" == "only" ]; then
		for script in "${AVAILABLE_SCRIPTS[@]}"; do
			for selected in "${selected_scripts[@]}"; do
				if [[ "$script" == "$selected" ]]; then
					scripts_to_run+=("$script")
				fi
			done
		done
	fi

	if [ "$flag" == "except" ]; then
		scripts_to_run=("${AVAILABLE_SCRIPTS[@]}")

		for del in "${selected_scripts[@]}"; do
			for i in "${!scripts_to_run[@]}"; do
				if [[ "${scripts_to_run[i]}" == "$del" ]]; then
					unset 'scripts_to_run[i]'
				fi
			done
		done
	fi
}

install() {
	if [ $# -gt 0 ]; then
		case $1 in
		-h | --help)
			usage
			exit 0
			;;
		-e | --except*)
			shift
			check_and_extract_arguments "except" "$@"
			run_scripts
			exit 0
			;;
		-o | --only*)
			shift
			check_and_extract_arguments "only" "$@"
			run_scripts
			exit 0
			;;
		*)
			echo "Invalid option: $1" >&2
			usage
			exit 1
			;;
		esac
  	fi

	scripts_to_run=("${AVAILABLE_SCRIPTS[@]}")
	run_scripts

	info "Finished installation of dotfiles. Please remember to reboot your system to apply all settings."
}

run_scripts() {
	for script in "${scripts_to_run[@]}"; do
    	. "$DOTFILES/_scripts/steps/$script.sh"
	done
}

while true; do
	osascript -e 'tell application "System Events" to keystroke "."'
	if [ $? -eq 0 ]; then
		 break
	fi
	sleep 1
done

install "$@"
