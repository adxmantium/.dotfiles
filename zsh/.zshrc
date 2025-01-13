# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY           # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # Ignore duplicated commands
setopt HIST_IGNORE_SPACE      # Ignore commands that start with space
setopt HIST_VERIFY           # Show command with history expansion before running it

# --------------------------------
# My Aliases
# --------------------------------
alias whatsmyip="ipconfig getifaddr en0"
alias ff='cd "$(fd -t d --exclude ~/Music/ --exclude ~/Movies/ --exclude ~/Library/ --exclude ~/Pictures/ . | fzf-tmux -p --reverse)"'
alias fo='vim "$(fd --exclude ~/Music/ --exclude ~/Movies/ --exclude ~/Library/ --exclude ~/Pictures/ --type f | fzf-tmux -p --reverse)"'
alias vim="nvim"
alias cht="~/.dotfiles/scripts/cheatsht/tmux-cht.sh"

# Modern CLI alternatives
alias ls='eza --icons'
alias la='eza -l --icons'
alias ll="eza -la --icons"
alias cat='bat'
alias find='fd'
alias htop='btop'
alias grep='rg'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias dotfiles='cd ~/.dotfiles'

# --------------------------------
# FZF configuration
# --------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# Set different FZF display options based on whether we're in tmux
if [ -n "$TMUX" ]; then
    export FZF_TMUX=1
    export FZF_TMUX_OPTS='-p 80%,60%'  # Use popup window
    export FZF_DEFAULT_OPTS='--layout=reverse --border'
else
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# Quick find-and-edit with fzf/fzf-tmux
fe() {
  local file

  if [ -n "$TMUX" ]; then
    file=$(command fzf-tmux -p 80%,60% --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%)
  else
    file=$(command fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%)
  fi

  if [ -n "$file" ]; then
    ${EDITOR:-nvim} "$file"
  fi
}

# --------------------------------
# Development environment
# --------------------------------
export EDITOR='nvim'
export VISUAL='nvim'

# --------------------------------
# Enables Vi mode in readline
# --------------------------------
bindkey -v

# Reduces lag time for vi mode input
export KEYTIMEOUT=1

# --------------------------------
# nvm init
# --------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --------------------------------
# pure prompt init
# --------------------------------
# autoload -U promptinit; promptinit
# prompt pure

# --------------------------------
# Zsh Syntax Highlighting init
# --------------------------------
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
   source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --------------------------------
# Disable oh-my-zsh themes (leave empty)
# - using powerlevel10k theme
# --------------------------------
ZSH_THEME="powerlevel10k/powerlevel10k"

# --------------------------------
# Zsh Autosuggestions init
# --------------------------------
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
   source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# bun completions
[ -s "/Users/adamadams/.bun/_bun" ] && source "/Users/adamadams/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
