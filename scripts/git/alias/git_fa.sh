#!/usr/bin/env bash

# Option 1: Using ANSI colors to indicate staged/unstaged
git status -s | \
  awk '{
    if (substr($0,1,1) != " ") {
      printf "\033[32m%s\033[0m\n", $0;  # Green for staged
    } else {
      print $0;  # Normal for unstaged
    }
  }' | \
  fzf --ansi --multi --preview-window up:90% \
      --header $'m = Modified (unstaged), M = Modified (staged), MM = Modified (staged & unstaged), A = Added (staged), ?? = Untracked, D = Deleted (staged), d = Deleted (unstaged), R = Renamed (staged), C = Copied (staged), U = Updated' \
      --preview '([[ $(echo {1}) =~ ^[[:upper:]] || $(echo {1}) =~ ^\033 ]] && git diff --staged --color=always {2} || git diff --color=always {2})' \
      --bind 'ctrl-t:execute(git status -s | grep -F "{2}" | grep -q "^[^ ]" && git reset -- {2} || git add {2})+reload(git status -s)' | \
  awk '{print $2}' | \
  xargs -r git add && git status
