#!/bin/zsh
#
# hound - Interactive code search with fuzzy finder
#
# Search your codebase with ripgrep, select results with fzf, and open
# in your editor of choice at the exact line number.
#
# DEPENDENCIES:
#   Required:
#     - rg (ripgrep)   : brew install ripgrep
#     - fzf            : brew install fzf
#   Optional:
#     - bat            : brew install bat (for syntax-highlighted preview, falls back to cat)
#     - nvim           : brew install neovim
#     - cursor         : Install 'cursor' command -> Cmd+Shift+P
#     - code (VSCode)  : Install 'code' command -> Cmd+Shift+P
#
# ENVIRONMENT VARIABLES:
#   VISUAL  : Preferred editor (modern standard)
#   EDITOR  : Fallback editor (traditional)
#   Editor precedence: arg > $VISUAL > $EDITOR > nvim
#
# INSTALL SUGGESTIONS (Here's what I did):
#   - Place this script in your dotfiles (or somewhere easy to remember)
#   - Add an alias to your shell config (e.g. ~/.zshrc):
#       alias hound="~/.dotfiles/scripts/hound.sh"
#   - Make it executable: chmod +x ~/.dotfiles/scripts/hound.sh
#   - Source your shell config: source ~/.zshrc
#   - `cd` into any git repo and run `hound --help` to see available options
#
# USAGE:
#   hound <query> [editor]
#   hound -h | --help
#
# EXAMPLES:
#   hound "useState"                # Search and open in default editor
#   hound "TODO" cursor             # Search and open in Cursor
#   hound "function" code           # Search and open in VSCode
#   hound "className" nvim          # Search and open in Neovim (quickfix list)
#   hound "onClick" gh              # Search and open in GitHub web view
#
# MULTI-SELECT:
#   In FZF mode, press Tab to select multiple results, Enter to confirm.
#   - nvim: Opens all matches in quickfix list (:cn/:cp to navigate)
#   - cursor/code: Opens each file in a new tab at its line
#   - gh: Opens multiple browser tabs
#
# NOTES:
#   - Excludes: vendor/, node_modules/, cache/, data/, lib/ (mostly from monolith)
#   - For GitHub (gh): Uses 'upstream' remote if available (forked repos), else 'origin'
#   - Auto-detects default branch (main/master) for GitHub URLs
#
# GOTCHAS:
#   - Have to be mindful of what branch you're in if you're not getting results you expect
#     - That could be no expected results seen in FZF
#     - Or, the line number is off when you open it github web view bc your branch is not main/master but web view is
#

show_help() {
  echo "Usage: hound <query> [editor]"
  echo "Supported editors/views: nvim (default), cursor, code, ui (GitHub)"
  echo ""
  echo "Editor precedence: arg > \$VISUAL > \$EDITOR > nvim"
  echo ""
  echo "Multi-select: Tab to select multiple, Enter to confirm"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

query=$1
action=${2:-${VISUAL:-${EDITOR:-nvim}}}

if [ -z "$query" ]; then
  echo "You forgot to provide a search query :sweat-smile:"
  show_help
  exit 1
fi

# Get the git remote URL and construct the GitHub web URL
get_github_url() {
  # Prefer upstream (forked repos) over origin
  local remote="upstream"
  local remote_url=$(git remote get-url upstream 2>/dev/null)

  if [ -z "$remote_url" ]; then
    remote="origin"
    remote_url=$(git remote get-url origin 2>/dev/null)
  fi

  if [ -z "$remote_url" ]; then
    echo "Error: Not in a git repository or no remote found" >&2
    exit 1
  fi

  # Convert SSH URL (git@github.com:user/repo.git) or HTTPS URL to web URL
  local web_url=$(echo "$remote_url" | sed -E 's|^git@([^:]+):|https://\1/|' | sed 's|\.git$||')

  # Detect default branch (main, master, etc.)
  local default_branch=$(git symbolic-ref "refs/remotes/${remote}/HEAD" 2>/dev/null | sed "s|refs/remotes/${remote}/||")
  default_branch=${default_branch:-main}

  echo "${web_url}/blob/${default_branch}"
}

# Search and select file(s):line with fzf (multi-select with Tab)
search_and_select() {
  rg -i --line-number --color=always -g "!vendor/**" -g "!node_modules/**" -g "!cache/**" -g "!data/**" -g "!lib/**" "$query" | \
    fzf --ansi \
        --multi \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1} || cat {1}' \
        --preview-window '+{2}/2'
}

# Open the selected results in the appropriate editor
open_results() {
  local selections="$1"

  case "$action" in
    nvim|vim)
      # Write selections to temp file in quickfix format (file:line:col:message)
      local tmpfile=$(mktemp)
      echo "$selections" > "$tmpfile"
      nvim -q "$tmpfile" -c "copen" </dev/tty
      rm -f "$tmpfile"
      ;;
    gh|ui)
      local github_base_url=$(get_github_url)
      while IFS=: read -r file line _rest; do
        [ -z "$file" ] && continue
        open "${github_base_url}/${file}#L${line}"
      done <<< "$selections"
      ;;
    cursor)
      while IFS=: read -r file line _rest; do
        [ -z "$file" ] && continue
        cursor --goto "${file}:${line}" </dev/null
      done <<< "$selections"
      ;;
    code)
      while IFS=: read -r file line _rest; do
        [ -z "$file" ] && continue
        code --goto "${file}:${line}" </dev/null
      done <<< "$selections"
      ;;
    *)
      echo "Unknown editor: $action"
      echo "Supported: nvim, cursor, code, gh/ui"
      exit 1
      ;;
  esac
}

selections=$(search_and_select)

if [ -n "$selections" ]; then
  open_results "$selections"
fi
