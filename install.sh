#!/bin/bash

set -e  # Exit on error
set -u  # Exit on undefined variable

STOW_FOLDERS="git,tmux,nvim,zsh,wezterm"
DOT_FILES=$HOME/.dotfiles

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Function to install a package if it's not already installed
install_if_missing() {
    if ! brew list "$1" >/dev/null 2>&1; then
        echo "Installing $1..."
        if [[ "$2" == "cask" ]]; then
            brew install --cask "$1"
        else
            brew install "$1"
        fi
    else
        echo "$1 is already installed"
    fi
}

echo "Installing required packages..."
# Core dependencies
install_if_missing "stow"

# Terminal and shell tools
install_if_missing "wezterm" "cask"
install_if_missing "font-meslo-lg-nerd-font" "cask"
install_if_missing "powerlevel10k"
install_if_missing "zsh-autosuggestions"
install_if_missing "zsh-syntax-highlighting"
install_if_missing "eza"
install_if_missing "tmux"
install_if_missing "neovim"
install_if_missing "git"

# Development tools
install_if_missing "fd"
install_if_missing "gh"
install_if_missing "lua"
install_if_missing "go"
install_if_missing "ripgrep"
install_if_missing "fzf"
install_if_missing "bat"
install_if_missing "htop"

echo "Setting up configuration files..."
pushd "$DOT_FILES" || exit 1
for folder in $(echo "$STOW_FOLDERS" | sed "s/,/ /g"); do
    echo "Configuring $folder..."
    stow -D "$folder" 2>/dev/null || true
    stow "$folder"
done
popd || exit 1

# Source shell configurations
echo "Sourcing configurations..."
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# Setup tmux plugins
echo "Setting up tmux plugins..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_PLUGIN_SCRIPT="$TPM_DIR/bin/install_plugins"

# Install TPM if not present
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing tmux plugin manager..."
    if ! git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
        echo "Failed to install TPM. Plugin installation will be skipped."
        exit 1
    fi
fi

# Verify plugin installation script exists
if [ ! -f "$TPM_PLUGIN_SCRIPT" ]; then
    echo "TPM plugin installation script not found at $TPM_PLUGIN_SCRIPT"
    echo "Your TPM installation might be corrupted. Try removing $TPM_DIR and running this script again."
    exit 1
fi

# Install tmux plugins non-interactively
echo "Installing tmux plugins..."
if ! "$TPM_PLUGIN_SCRIPT"; then
    echo "Plugin installation failed. You may need to install them manually with prefix + I inside tmux"
    exit 1
fi

echo "Tmux plugins installed successfully!"

# Start a new tmux session if we're not already in one
if [ -z "${TMUX:-}" ]; then
    echo "Starting new tmux session..."
    tmux new-session
fi

echo "Installation complete! 🎉"
