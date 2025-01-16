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

# Safety first - prevent dangerous rm commands
safer_rm() {
    # Prevent rm -rf / or rm -rf /*
    if [[ "$*" =~ ^-[[:alnum:]]*[fF][[:alnum:]]*[[:space:]]*(\/|\/\*) ]]; then
        echo "Error: Attempting to remove root directory or its contents. Operation blocked for safety."
        return 1
    fi
    
    # Call the real rm command
    command rm "$@"
}

# Set up the alias for safer rm
alias rm='safer_rm'

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

# Configure CTRL-T, CTRL-R, and ALT-C behavior when in tmux
if [ -n "$TMUX" ]; then
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}' --preview-window=right:60%"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:hidden:wrap --bind '?:toggle-preview'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
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
# for colors to appear correctly in wezterm, 
# you need this line & download term definition from https://wezfurlong.org/wezterm/config/lua/config/term.html
export TERM='wezterm'

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
# Zsh Syntax Highlighting init
# --------------------------------
if [ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
   source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --------------------------------
# Zsh Autosuggestions init
# --------------------------------
if [ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --------------------------------
# bun
# --------------------------------
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
[ -s "/Users/adamadams/.bun/_bun" ] && source "/Users/adamadams/.bun/_bun"

# --------------------------------
# Initialize starship prompt
# --------------------------------

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]; then
  source ~/powerlevel10k/powerlevel10k.zsh-theme
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
