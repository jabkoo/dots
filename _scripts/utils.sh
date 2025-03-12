#!/bin/sh

export DOTFILES=${DOTFILES:-$HOME/dots}

COLOR_GRAY="\033[1;38;5;243m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
	printf "\n"
	printf "%b==============================%b\n" "${COLOR_GRAY}" "${COLOR_NONE}"
	printf "%s%b\n" "$1" "${COLOR_NONE}"
	printf "%b==============================%b\n" "${COLOR_GRAY}" "${COLOR_NONE}"
	printf "\n"
}

err() {
	printf "%b❌ Error: %s%b\n" "${COLOR_RED}" "$1" "${COLOR_NONE}" >&2
}

err_exit() {
	err "$1 Aborting script execution..." >&2
	exit 1
}

warn() {
	printf "%b⚠️  Warning: %s%b\n" "${COLOR_YELLOW}" "$1" "${COLOR_NONE}"
}

info() {
	printf "ℹ️  Info: %s\n" "$1"
}

ok() {
	printf "%b✅ Sucess: %s%b\n" "${COLOR_GREEN}" "$1" "${COLOR_NONE}"
}
