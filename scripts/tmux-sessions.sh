#!/bin/bash

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
selected_session=$(echo "$sessions" | fzf-tmux --print-query --reverse -p --prompt="Tmux switch to custom session > ")

# grab last line from text stream
# this is need bc --print-query will always output whatever is typed, 
#   even when you select an option from the list, so it kind of duplicates the text
# In the text stream, the first line is the word you typed in the search input
#   and the second line is what was selected
# When searched text does not match anything in the list of options, just that query is outputed
#   so that's why we just grab the last line in the text stream to account for both situations
selected=$(echo "$selected_session" | tail -n 1)

 # If a session was selected, check if it already exists
if [ -n "$selected" ]; then
  if tmux has-session -t "$selected" 2>/dev/null; then
    tmux switch-client -t "$selected"
  else
    # If it doesn't exist, create and switch to it
    tmux new-session -ds "$selected"
    tmux switch-client -t "$selected"
  fi
fi

