# Dotfiles — Terminal-First, Explicit, Reproducible

This repository contains my full development environment configuration.

The guiding principles are:

- Explicit tooling (no Mason, no hidden downloads)
- Reproducible setup on a brand-new machine
- Terminal-first workflow
- GitHub Dark Dimmed everywhere
- Minimal UI (no icons, no italics)
- Clear separation between plugins, binaries, and glue code

All configuration lives under ~/.config where possible.

---

## What’s Included

### Shell
- zsh (interactive shell)
- Oh My Zsh (plugin framework, minimal plugins)
- fzf history search (fuzzy Ctrl-R)
- fnm (Fast Node Manager for Node.js)
- corepack (pnpm shim and version management)

### Terminal
- Alacritty (GPU-accelerated terminal)
- GitHub Dark Dimmed colors (theme)
- zsh as login shell (default shell)

### Multiplexer
- tmux (>= 3.2 for display-popup)
- Prefix: Ctrl + Space (tmux prefix key)
- i3-style pane navigation (Alt + H/J/K/L)
- fzf session picker (popup UI)
- GitHub Dark Dimmed statusline (theme)
- macOS clipboard integration (pbcopy)

### Editor
- Neovim (Lua config)
- lazy.nvim (plugin manager)
- Built-in LSP (Neovim >= 0.11)
- Tree-sitter (new rewrite API)
- nvim-cmp (completion, no snippets)
- format-on-save (BufWritePre)
- explicit external tooling (no auto-downloads)

### Language Support
- Go (gopls)
- Rust (rust-analyzer)
- TypeScript / JavaScript (typescript-language-server)
- JSON / YAML / TOML (vscode-json-languageserver, yaml-language-server, taplo)
- XML formatting (xmllint)
- C# via roslyn.nvim + Roslyn Language Server (manual install)
- Debugging via DAP (netcoredbg, vscode-js-debug)

---

## Assumptions

- macOS (Apple Silicon)
- Xcode Command Line Tools available
- You are comfortable installing some tools manually
- tmux >= 3.2 available on PATH

---

## New Machine Setup (Step-by-Step)

### 1. Install Xcode Command Line Tools

Installs Apple command line tools used by compilers and build tools:

xcode-select --install

Verify:

xcode-select -p

---

### 2. Install Homebrew

Installs Homebrew package manager:

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Enable brew in login shells:

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

Restart your shell:

exec zsh -l

---

### 3. Clone This Repository

Clone your dotfiles repo to a local directory:

git clone <YOUR_REPO_URL> <DOTFILES_DIR>

Example:

git clone git@github.com:yourname/dotfiles.git ~/Code/dotfiles

---

### 4. Link Configs into ~/.config

Create symlinks so each tool reads from this repo:

mkdir -p ~/.config

ln -snf <DOTFILES_DIR>/alacritty ~/.config/alacritty
ln -snf <DOTFILES_DIR>/tmux      ~/.config/tmux
ln -snf <DOTFILES_DIR>/nvim      ~/.config/nvim
ln -snf <DOTFILES_DIR>/yabai     ~/.config/yabai
ln -snf <DOTFILES_DIR>/skhd      ~/.config/skhd

---

### 5. Set zsh as Login Shell

Make zsh the default login shell:

chsh -s /bin/zsh

Open a new terminal and confirm:

echo "$SHELL"

---

### 6. Install Oh My Zsh

Install the Oh My Zsh framework:

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

Replace ~/.zshrc with the version from this repo.

---

### 7. Install Core CLI Tools

Install required CLI tools and build dependencies:

brew install alacritty tmux fzf ripgrep fd git tree-sitter-cli make llvm

Optional XML formatter (xmllint is used for XML formatting in Neovim):

brew install libxml2

---

### 8. Node.js Tooling

Install the Node.js version manager and pnpm tooling:

brew install fnm

Add to ~/.zprofile:

eval "$(fnm env --use-on-cd)"

fnm install --lts
fnm use --lts

corepack enable
corepack prepare pnpm@latest --activate

---

### 9. Neovim

Install Neovim and bootstrap plugins:

brew install neovim

First launch:

nvim

Then inside Neovim:

:Lazy sync

Restart Neovim.

---

### 10. Tree-sitter Parsers

Install language parsers used by tree-sitter:

Inside Neovim:

:TSInstall all

---

### 11. LSP Binaries

Install language server binaries:

brew install gopls rust-analyzer taplo yaml-language-server

npm install -g typescript typescript-language-server vscode-json-languageserver

---

### 12. C# — Roslyn Language Server (Manual)

Install Roslyn language server payload:

mkdir -p ~/.local/share/lsp/roslyn

Download Microsoft.CodeAnalysis.LanguageServer.neutral nupkg.

unzip Microsoft.CodeAnalysis.LanguageServer.neutral.*.nupkg -d ~/.local/share/lsp/roslyn

Verify:

cd ~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64
dotnet Microsoft.CodeAnalysis.LanguageServer.dll --version

---

### 13. Debuggers

Install debugger binaries used by DAP:

brew install go-delve

Follow netcoredbg build instructions (documented in this repo).

---

## Daily Usage

- Ctrl + Space — tmux prefix
- Space Space — Telescope buffers
- Space f — format buffer
- Space g g — lazygit
- Space g b — inline git blame

---

## Philosophy

- Plugins are managed by lazy.nvim
- Language servers and debuggers are installed explicitly
- Configuration is Lua, modular, and readable
- No magic, no auto-downloads, no silent behavior
