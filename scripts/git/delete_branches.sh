#!/bin/bash

selected_branches=$(git branch --format="%(refname:short)" | grep -vE '^(main|master)$' | fzf-tmux --multi --preview="git show --color=always {}")

if [ -z "$selected_branches" ]; then
  echo "No branches selected"
  exit 0
fi

for branch in $selected_branches; do
  git branch -d "$branch" >/dev/null 2>&1

  if [ $? -ne 0 ]; then
    read -p "Branch '$branch' cannot be deleted. Do you want to force delete it? (y/n): " choice

    case "$choice" in
      y|Y ) # selected yes
        git branch -D "$branch"
        echo "Branch '$branch' was force deleted successfully!"
        ;;
      n|N ) # no selected
        echo "Branch '$branch' was not deleted"
        ;;
      * ) # catch all
        echo "Invalid choice. Branch '$branch' was not deleted"
        ;;
    esac
    echo "Branch '$branch' was deleted successfully!"
  fi
done
