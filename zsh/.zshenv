#!/bin/sh

# Exports
export DOTFILES=${DOTFILES:-$HOME/dots}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

export STARSHIP_CONFIG=${STARSHIP_CONFIG:-$ZDOTDIR/starship.toml}

export TERM='xterm-256color'
export EDITOR='nvim'
export VISUAL='nvim'

export LC_ALL="en_GB.UTF-8"
export LANG="en_GB"

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Set the list of directories that zsh searches for commands.
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $HOME/.rd/bin(N)
  $path
)
