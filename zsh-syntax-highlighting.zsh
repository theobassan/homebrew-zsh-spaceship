#!/bin/zsh

ZSH_SPACESHIP_ZSH_SYNTAX_HIGHLIGHTING_FOLDER="${ZSH_SPACESHIP_ZSH_SYNTAX_HIGHLIGHTING_FOLDER=$(brew --prefix)/share/zsh-syntax-highlighting}"

source "$ZSH_SPACESHIP_ZSH_SYNTAX_HIGHLIGHTING_FOLDER/zsh-syntax-highlighting.zsh" || return