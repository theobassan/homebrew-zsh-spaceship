#!/bin/zsh

local aliasesDir="${0:A:h}"
source "$aliasesDir/git-aliases.zsh" || return
source "$aliasesDir/homebrew-command-not-found.zsh" || return
source "$aliasesDir/you-should-use.zsh" || return

alias :q=exit
alias ..='cd ..'
alias -- -='cd -'
alias gcz="npx git-cz"
alias code='open -a "Visual Studio Code"'