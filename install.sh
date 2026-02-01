#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Dotfiles directory: $DOTFILES"

# 1. Homebrew
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found."
    echo "Install it from https://brew.sh and re-run this script."
    exit 1
fi

# 2. Brew bundle
if [ -f "$DOTFILES/Brewfile" ]; then
    echo "Running brew bundle..."
    brew bundle --file="$DOTFILES/Brewfile"
else
    echo "No Brewfile found, skipping brew bundle."
fi

# 3. Symlink config directories
mkdir -p "$CONFIG_DIR"
for dir in alacritty tmux nvim zsh yabai skhd gh git; do
    src="$DOTFILES/$dir"
    dest="$CONFIG_DIR/$dir"
    if [ -d "$src" ]; then
        if [ -L "$dest" ]; then
            echo "Already linked: $dir"
        elif [ -d "$dest" ]; then
            echo "WARNING: $dest exists and is not a symlink. Skipping."
        else
            ln -snf "$src" "$dest"
            echo "Linked: $dir -> $dest"
        fi
    fi
done

# 4. ZDOTDIR in ~/.zshenv
ZSHENV="$HOME/.zshenv"
ZDOTDIR_LINE='export ZDOTDIR="$HOME/.config/zsh"'
if [ -f "$ZSHENV" ] && grep -qF 'ZDOTDIR' "$ZSHENV"; then
    echo "~/.zshenv already sets ZDOTDIR."
else
    cat <<'EOF' > "$ZSHENV"
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshenv"
EOF
    echo "Created ~/.zshenv with ZDOTDIR."
fi

# 5. Oh My Zsh + autosuggestions
OMZ_DIR="$CONFIG_DIR/zsh/oh-my-zsh"
if [ ! -d "$OMZ_DIR" ]; then
    echo "Cloning Oh My Zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
else
    echo "Oh My Zsh already installed."
fi

AUTOSUGGEST_DIR="$OMZ_DIR/custom/plugins/zsh-autosuggestions"
if [ ! -d "$AUTOSUGGEST_DIR" ]; then
    echo "Cloning zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$AUTOSUGGEST_DIR"
else
    echo "zsh-autosuggestions already installed."
fi

# 6. TPM
TPM_DIR="$CONFIG_DIR/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Cloning TPM..."
    mkdir -p "$CONFIG_DIR/tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM already installed."
fi

# 7. Summary
echo ""
echo "Done. Next steps:"
echo "  - Open tmux and press prefix + I to install plugins"
echo "  - Open nvim and run :Lazy sync"
echo "  - Restart your shell or run: source ~/.zshenv && source ~/.config/zsh/.zshrc"
