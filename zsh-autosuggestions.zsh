#!/bin/zsh

ZSH_SPACESHIP_ZSH_AUTOSUGGESTIONS_FOLDER="${ZSH_SPACESHIP_ZSH_AUTOSUGGESTIONS_FOLDER=$(brew --prefix)/share/zsh-autosuggestions}"

source "$ZSH_SPACESHIP_ZSH_AUTOSUGGESTIONS_FOLDER/zsh-autosuggestions.zsh" || return

#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"