#!/bin/zsh

CURRENT_SPACESHIP_ALIASES_DIR="${0:A:h}"
source "$CURRENT_SPACESHIP_ALIASES_DIR/git-aliases.zsh" || return
source "$CURRENT_SPACESHIP_ALIASES_DIR/homebrew-command-not-found.zsh" || return
source "$CURRENT_SPACESHIP_ALIASES_DIR/you-should-use.zsh" || return

alias gcz="npx git-cz"