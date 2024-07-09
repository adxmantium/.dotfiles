# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------------------------
# My Aliases
# --------------------------------
alias ll="eza -la --icons"
alias whatsmyip="ipconfig getifaddr en0"
alias oaklandWeather="curl wttr.in/oakland"
alias atlantaWeather="curl wttr.in/atlanta"
alias walnutcreekWeather="curl wttr.in/walnut-creek"
alias edit="vim ~/.zshrc"
alias view="cat ~/.zshrc"
alias openports="lsof -i"
alias cat="bat"
alias ff='cd "$(fd -t d --exclude ~/Music/ --exclude ~/Movies/ --exclude ~/Library/ --exclude ~/Pictures/ . | fzf-tmux -p --reverse)"'
alias fo='vim "$(fd --exclude ~/Music/ --exclude ~/Movies/ --exclude ~/Library/ --exclude ~/Pictures/ --type f | fzf-tmux -p --reverse)"'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias vim="nvim"
alias zel="zellij"
alias vimconfig="vim ~/.zshrc"
alias tmuxconfig="vim ~/.tmux.conf"
alias neovimconfig="vim ~/.config/nvim"
alias ts="~/.dotfiles/scripts/tmux-sessions.sh"
alias tsd="~/.dotfiles/scripts/tmux-delete-sessions.sh"
alias tsf="~/.dotfiles/scripts/find_and_open_file_in_vim.sh"
alias cht="~/.dotfiles/scripts/cheatsht/tmux-cht.sh"

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
