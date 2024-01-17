#!/usr/bin/env bash

selected=`cat ~/.dotfiles/scripts/cheatsht/cht-languages ~/.dotfiles/scripts/cheatsht/cht-commands | fzf --reverse --prompt="Search cheatsheet > "`

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.dotfiles/scripts/cheatsht/cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less -r"
fi
