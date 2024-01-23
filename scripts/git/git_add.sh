#!/usr/bin/env bash

preview="
arg=\$(echo {})
file=\$(echo \"\$arg\" | cut -c 4-)
if [[ -n \"\$(git diff --name-only \$file)\" ]]; then
  git diff --color=always -- \"\$file\"
elif [[ -n \"\$(git diff --staged --name-only \$file)\" ]]; then
  git diff --staged --color=always -- \"\$file\"
else
  echo \"Untracked file: \$file\"
fi
"

git status -su | fzf-tmux -p -m --preview="$preview" --prompt="Select files to stage > " | awk '{print $2}' | xargs git add --
