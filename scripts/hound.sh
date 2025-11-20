#!/bin/zsh

query=$1
action=$2

if [ -z "$query" ]; then
  echo "You forgot to provide a search query :sweat-smile:"
  exit 1
fi

# Get the git remote url and construct the Github web url
get_github_url() {
  local remote_url=$(git remote get-url origin 2>/dev/null)
  local branch=$(git branch --show-current 2>/dev/null || echo "main")

  if [ -z "$remote_url" ]; then
    echo "Error: Not in a git repo or no origin remote found" >&2
    exit 1
  fi

  #Convert ssh url or https url to web url
  local web_url=$(echo "$remote_url" | sed -E 's|^git@([^:]+):|https://\1/|' | sed 's|\.git$||')

  echo "${web_url}/blob/${branch}"
}

github_base_url=$(get_github_url)

if [ "$action" = "ui" ]; then
  # open in github
  rg -i --line-number --color=always -g "!vendor/**" -g "!node_modules/**" -g "!cache/**" "$query" | \
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1} || cat {1}' \
        --preview-window '+{2}/2' | \
    awk -F: -v base="$github_base_url" '{print base"/"$1"#L"$2}' | \
    xargs open
else
  # open in nvim
  rg -i --line-number --color=always -g "!vendor/**" -g "!node_modules/**" -g "!cache/**" "$query" | \
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1} || cat {1}' \
        --preview-window '+{2}/2' | \
    awk -F: '{print "+"$2, $1}' | \
    xargs -o nvim
fi
