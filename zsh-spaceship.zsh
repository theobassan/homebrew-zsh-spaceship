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

CURRENT_DIR="${0:A:h}"
source "$CURRENT_DIR/zsh-fzf.zsh" || return
source "$CURRENT_DIR/zsh-history.zsh" || return
source "$CURRENT_DIR/zsh-cursor.zsh" || return
source "$CURRENT_DIR/zsh-autosuggestions.zsh" || return
source "$CURRENT_DIR/zsh-syntax-highlighting.zsh" || return
source "$CURRENT_DIR/zsh-completions.zsh" || return
source "$CURRENT_DIR/zsh-z.zsh" || return
source "$CURRENT_DIR/zsh-direnv.zsh" || return
source "$CURRENT_DIR/zsh-mise.zsh" || return
source "$CURRENT_DIR/aliases/zsh-aliases.zsh" || return
source "$CURRENT_DIR/spaceship-prompt/zsh-spaceship-prompt.zsh" || return