#!/usr/bin/env bash

DOTS="dots"
DOTS_DIR="$HOME/$DOTS"
DOTS_REPO="https://github.com/jabkoo/$DOTS"

if command -v git; then
	cd "$HOME"
	git clone "$DOTS_REPO" "$DOTS_DIR"
	chmod +x "$DOTS_DIR"
	cd "$DOTS_DIR" || exit
	./_scripts/install "$@"
else
	cd "$HOME"
	curl -LO "$DOTS_REPO/archive/main.zip"
	unzip main.zip
	rm -rf main.zip
	mv "$DOTS-main" "$DOTS_DIR"
	chmod +x "$DOTS_DIR"
	cd "$DOTS_DIR" || exit
	./_scripts/install "$@"
fi
