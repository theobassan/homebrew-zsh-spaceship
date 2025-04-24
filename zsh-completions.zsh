#!/bin/zsh

ZSH_SPACESHIP_ZSH_COMPLETIONS_FOLDER="${ZSH_SPACESHIP_ZSH_COMPLETIONS_FOLDER=$(brew --prefix)/share/zsh-completions}"

fpath+=$ZSH_SPACESHIP_ZSH_COMPLETIONS_FOLDER

# navigate menu for command output
zstyle ':completion:*:*:*:*:*' menu select
bindkey '^[[Z' reverse-menu-complete

autoload -Uz compinit
compinit