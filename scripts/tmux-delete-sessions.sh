#!/bin/bash

# run using: ~/scripts/tmux/tmux-delete-sessions.sh

# get current session name
current_session=$(tmux display-message -p '#S')

# Check if in a tmux session
if [ -n "$TMUX" ]; then
  # If in a tmux session, use the current session as the default option
  sessions=$(tmux list-sessions -F "#{session_name}" | grep -v "^$current_session$")
else
  # If not in a tmux session, list all sessions
  sessions=$(tmux list-sessions -F "#{session_name}")
fi

# Use fzf to select a tmux session
selected_session=$(echo "$sessions" | fzf-tmux --print-query --reverse -p --prompt="Select session to delete > ")

# whatdis=$(echo "$selected_session" | tr -d '\n')
line_count=$(echo "$selected_session" | wc -l)

if [[ $line_count -eq 2 ]]; then
  session_trimmed=$(echo "$selected_session" | tail -n +2)
  tmux kill-session -t $session_trimmed
  echo "session '$session_trimmed' deleted"
else
  echo "session '$selected_session' does not exist. Exiting."
fi
