#!/bin/bash

# define filtered list of dirs to search through
search_directories=(
~/Dev
~/scripts
~/.dotfiles
)

# use find to find files in filtered list of dirs & store selection in a var
selected=$(find "${search_directories[@]}" -type f | fzf-tmux -p --reverse --prompt="Select file > ")

# if selected, the open in vim
if [ -n "$selected" ]; then
  nvim "$selected"
else
  echo "no file selected"
fi
