#!/bin/bash

set -e  # Exit on error
set -u  # Exit on undefined variable

STOW_FOLDERS="git,tmux,nvim,zsh,wezterm,starship"
DOT_FILES=$HOME/.dotfiles

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install all dependencies from Brewfile
echo "Installing packages from Brewfile..."
if ! brew bundle --file=./Brewfile; then
    echo "Failed to install packages from Brewfile"
    exit 1
fi

# Set up fzf integration
if [ ! -f "$HOME/.fzf.zsh" ]; then
    echo "Setting up fzf key bindings and completion..."
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# Install nvm (Node Version Manager) & node
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    LATEST_NVM=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_NVM/install.sh | bash

    # Load nvm immediately for the rest of the script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest Node.js
    echo "Installing latest Node.js..."
    nvm install node # "node" is an alias for the latest version
    nvm alias default node # Set the latest version as default
fi

# Initialize stow configurations
echo "Setting up configuration files..."
pushd "$DOT_FILES" || exit 1
for folder in $(echo "$STOW_FOLDERS" | sed "s/,/ /g"); do
    echo "Configuring $folder..."
    stow -D "$folder" 2>/dev/null || true
    stow "$folder"
done
popd || exit 1

# Set up tmux plugins
echo "Setting up tmux plugins..."
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Install TPM if not present
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install tmux plugins non-interactively
if [ -f "$TPM_DIR/bin/install_plugins" ]; then
    echo "Installing tmux plugins..."
    "$TPM_DIR/bin/install_plugins"
else
    echo "Note: You'll need to manually install tmux plugins by pressing prefix + I inside tmux"
fi

# Source shell configurations
echo "Sourcing configurations..."
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# Start a new tmux session if we're not already in one
if [ -z "${TMUX:-}" ]; then
    echo "Starting new tmux session..."
    tmux new-session
fi

echo "Installation complete! 🎉"
