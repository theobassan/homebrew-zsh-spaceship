#!/bin/zsh

# set the locale of the shell
export LANG="en_US.UTF-8"

# define VSCode as the default text editor
export EDITOR="code -w"

# enable comments "#" expressions in the prompt shell
setopt INTERACTIVE_COMMENTS

# delete characters using the "delete" key
bindkey "^[[3~" delete-char

# enable kubectl plugin autocompletion
#source "$HOME/.my-custom-zsh/kubectl.plugin.zsh"
#source <(kubectl completion zsh)

local rootDir="${0:A:h}"
source "$rootDir/zsh-fzf.zsh" || return
source "$rootDir/zsh-history.zsh" || return
source "$rootDir/zsh-cursor.zsh" || return
source "$rootDir/zsh-autosuggestions.zsh" || return
source "$rootDir/zsh-syntax-highlighting.zsh" || return
source "$rootDir/zsh-completions.zsh" || return
source "$rootDir/zsh-zoxide.zsh" || return
source "$rootDir/zsh-direnv.zsh" || return
source "$rootDir/zsh-mise.zsh" || return
source "$rootDir/aliases/zsh-aliases.zsh" || return
source "$rootDir/spaceship-prompt/zsh-spaceship-prompt.zsh" || return