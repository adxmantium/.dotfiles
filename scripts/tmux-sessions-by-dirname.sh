#!/bin/bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/.dotfiles ~/.dotfiles/nvim/.config ~/.config ~/Dev ~/scripts -mindepth 1 -maxdepth 1 -type d | fzf-tmux -p --reverse --prompt="Tmux switch by dirname > ")
fi

if [[ -z $selected ]]; then
    echo "No directory selected"
    exit 0
fi

selected_name=$(echo "$selected" | sed 's|^/Users/adamadams||' | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
