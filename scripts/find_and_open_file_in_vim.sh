#!/bin/bash

# define filtered list of dirs to search through
search_directories=(
~/Dev
~/scripts
)

# use find to find files in filtered list of dirs & store selection in a var
selected=$(find "${search_directories[@]}" -type f | fzf-tmux -p --reverse --prompt="Select a file...")

# if selected, the open in vim
if [ -n "$selected" ]; then
  cd "$(dirname "$selected_file")"
  nvim "$selected"
fi
