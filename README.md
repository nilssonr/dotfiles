# Dotfiles — Terminal-first, explicit, reproducible (macOS-first)

This repository contains my personal development-environment configuration.

It is organized as **XDG-style config directories** that are intended to be symlinked into `~/.config`.

## Principles

- **Explicit tooling**: language servers/debuggers are installed manually (no Mason, no silent binary downloads)
- **Reproducible**: configuration is versioned; Neovim plugins are pinned via `nvim/lazy-lock.json`
- **Terminal-first**: Alacritty + tmux + Neovim
- **Consistent theme**: GitHub Dark Dimmed across terminal/editor where possible
- **Minimal UI**: no icons, no italics, text-first affordances

All configuration lives under `~/.config` where possible.

---

## Scope / platform

- Primary target: **macOS (Apple Silicon)**
- macOS-only: `yabai/`, `skhd/`
- Cross-platform-ish: `tmux/` (battery script supports macOS via `pmset` and Linux via `upower`)

---

## Repository layout

These directories map directly to `~/.config/*`:

- `alacritty/` → `~/.config/alacritty`
- `tmux/` → `~/.config/tmux`
- `nvim/` → `~/.config/nvim`
- `zsh/` → `~/.config/zsh` (**requires `ZDOTDIR`**)
- `yabai/` → `~/.config/yabai` (macOS)
- `skhd/` → `~/.config/skhd` (macOS)
- `gh/` → `~/.config/gh`

---

## Quickstart (new machine)

### 1) Prerequisites

Install Xcode Command Line Tools:

```sh
xcode-select --install
```

Install Homebrew using the official installer.

### 2) Clone

```sh
git clone https://github.com/nilssonr/dotfiles.git ~/Code/dotfiles
```

### 3) Symlink into `~/.config`

```sh
DOTFILES="$HOME/Code/dotfiles"
mkdir -p "$HOME/.config"

for d in alacritty tmux nvim zsh yabai skhd gh; do
  ln -snf "$DOTFILES/$d" "$HOME/.config/$d"
done
```

### 4) Point zsh at `~/.config/zsh` (ZDOTDIR)

Create or edit `~/.zshenv` so zsh reads config from `~/.config/zsh`:

```sh
cat <<'EOF' > ~/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshenv"
EOF
```

If you already have a `~/.zshenv`, merge the two lines instead of overwriting.

### 5) Install core packages

```sh
brew install \
  alacritty tmux neovim \
  fzf ripgrep fd git \
  tree-sitter-cli llvm make \
  lazygit gh
```

Optional (used by specific features):

```sh
brew install fnm libxml2
```

Notes:
- `libxml2` provides `xmllint` (used for XML formatting in Neovim).
- `fnm` and Corepack are used for Node.js + pnpm workflows.

### 6) Fonts

Alacritty is configured to use `JetBrainsMono Nerd Font`.

Install a Nerd Font (choose one approach):

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

Or install the font manually and adjust `alacritty/alacritty.toml` if you prefer a non-nerd font.

### 7) Oh My Zsh + autosuggestions

This repo intentionally does **not** vendor Oh My Zsh.

```sh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git \
  ~/.config/zsh/oh-my-zsh

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
  ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-autosuggestions
```

### 8) tmux plugins (TPM)

TPM is expected at `~/.config/tmux/plugins/tpm`:

```sh
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then in tmux:
- Press the tmux prefix (`Ctrl` + `Space`)
- Press `I` (capital i) to install plugins

### 9) Neovim

First launch:

```sh
nvim
```

Then inside Neovim:

```vim
:Lazy sync
```

Language servers, debuggers, and Roslyn install steps are documented in:
- `nvim/README.md`
Includes `bash-language-server` for `sh`/`bash`/`zsh`.

### 10) yabai + skhd (macOS)

Install:

```sh
brew install yabai skhd
```

Start services:

```sh
brew services start yabai
brew services start skhd
```

You must also grant Accessibility permissions to yabai/skhd (System Settings → Privacy & Security → Accessibility).

**Note:** The space-movement keybindings (`alt+shift - 1..5` in `skhd/skhdrc`) require the yabai scripting addition to be enabled. See the [yabai wiki](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition) for setup instructions.

---

## Keybindings (cheatsheet)

### tmux

- Prefix: `Ctrl` + `Space`
- Focus panes: `Alt` + `h/j/k/l`
- Resize panes: `Alt` + `Shift` + `H/J/K/L`
- Split panes:
  - Prefix + `v` → horizontal split (left/right)
  - Prefix + `h` → vertical split (top/bottom)
- Session picker (popup): Prefix + `f`
- New session (prompt): Prefix + `C`
- Rename session (prompt): Prefix + `R`

Note: new panes/windows intentionally start in `$HOME` (see `tmux/tmux.conf`).

### Neovim

Leader is `Space`.

- Buffers: `<leader><leader>`
- Find files: `<leader>ff`
- Live grep: `<leader>fg`
- Help: `<leader>fh`
- Format buffer: `<leader>f`
- File browser (nvim-tree): `<leader>fb`
- Lazygit (floating terminal): `<leader>lg`
- Git blame (toggle line): `<leader>gb`
- Diagnostics float: `<leader>e`
- Diagnostic navigation: `[d` / `]d`

DAP:
- Continue: `<F5>`
- Step over: `<F10>`
- Step into: `<F11>`
- Step out: `<F12>`
- Toggle breakpoint: `<leader>b`

Note: when launching Neovim with no file args, it shows a small “What are you here to do?” intent buffer.

### zsh

- Project picker: `p` (alias for `cproj`)
- Project picker widget: `Ctrl` + `P`

### yabai / skhd (macOS)

- Focus window: `Alt` + `h/j/k/l`
- Move window: `Shift` + `Alt` + `h/j/k/l`
- Resize window: `Ctrl` + `Alt` + `h/j/k/l`
- Balance layout: `Ctrl` + `Alt` + `e`
- Toggle float + border: `Shift` + `Alt` + `Space`
- Fullscreen:
  - `Alt` + `f` → yabai zoom fullscreen
  - `Shift` + `Alt` + `f` → macOS native fullscreen

---

## Local overrides

Recommended pattern:

- `~/.config/zsh/local.zsh` (machine-specific env vars, work-specific PATH, etc.)
- `~/.config/nvim/lua/local.lua` (machine-specific editor tweaks)

Keep these files out of git.

---

## Tests

There is a small headless Neovim test for the Angular LSP config:

```sh
nvim --headless -u NONE -c "lua dofile('nvim/tests/angular_lsp.lua')" -c "qa"
```

---

## Security notes

- Treat `gh/hosts.yml` as **high risk**: `gh auth login` can write auth tokens into it.
  If a token ever gets committed, rotate it and scrub git history.

---

## Maintenance

- Homebrew: `brew update && brew upgrade`
- Neovim plugins: `:Lazy update` (commit the updated `nvim/lazy-lock.json`)
