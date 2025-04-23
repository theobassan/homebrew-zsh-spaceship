#!/bin/zsh

# specify characters considered as word boundaries for command line navigation
export WORDCHARS=""

# use the ZLE (zsh line editor) in emacs mode. Useful to move the cursor in large commands
bindkey -e

# navigate words using Ctrl + arrow keys
# >>> CRTL + right arrow | CRTL + left arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# macosx override
if [[ "$OSTYPE" == "darwin"* ]]; then 
  # >>> OPT + right arrow | OPT + left arrow
  bindkey "^[^[[C" forward-word
  bindkey "^[^[[D" backward-word
fi

# jump to the start and end of the command line
# >>> Home | End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
