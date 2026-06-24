# Dotfiles

Terminal-first, explicit, reproducible development environment for macOS (Apple Silicon).

## Principles

- **Terminal-first**: Alacritty + tmux + Neovim — no Electron IDE
- **Explicit tooling**: language servers, debuggers, and formatters are installed manually (no Mason, no silent binary downloads)
- **Reproducible**: configuration is versioned; Neovim plugins are pinned via `nvim-pack-lock.json`
- **Consistent theme**: GitHub Dark Dimmed across terminal, editor, and tmux
- **Minimal UI**: no icons, no italics, text-first affordances (ASCII glyphs everywhere)
- **XDG layout**: everything lives under `~/.config`

## Platform

- Primary: **macOS (Apple Silicon)**
- macOS-only: `yabai/`, `skhd/`
- Cross-platform-ish: `tmux/` (battery script supports macOS via `pmset` and Linux via `upower`)

---

## Repository layout

Each directory maps directly to `~/.config/<name>`:

| Directory    | Purpose                                |
|------------- |----------------------------------------|
| `alacritty/` | Terminal emulator config + color theme |
| `tmux/`      | tmux config, scripts, TPM plugins      |
| `nvim/`      | Neovim (Lua, native `vim.pack`)        |
| `zsh/`       | Shell config (requires `ZDOTDIR`)      |
| `git/`       | Global gitignore                       |
| `yabai/`     | Tiling window manager (macOS)          |
| `skhd/`      | Hotkey daemon (macOS)                  |

Additional files:

- `Brewfile` — declarative Homebrew dependencies
- `install.sh` — idempotent bootstrap script

---

## Quickstart (new machine)

### Automated

```sh
xcode-select --install
# Install Homebrew from https://brew.sh

git clone https://github.com/nilssonr/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles
bash install.sh
```

The install script will:
1. Run `brew bundle` from the Brewfile
2. Symlink config directories into `~/.config`
3. Set up `ZDOTDIR` in `~/.zshenv`
4. Clone Oh My Zsh + zsh-autosuggestions (if missing)
5. Clone TPM (if missing)

After running, open tmux and press `prefix + I` to install tmux plugins, then open nvim — plugins install automatically on first launch via `vim.pack`. Run `:checkhealth` to confirm.

### Manual

If you prefer to do it step by step:

```sh
# 1. Clone
git clone https://github.com/nilssonr/dotfiles.git ~/Code/dotfiles

# 2. Symlink
DOTFILES="$HOME/Code/dotfiles"
mkdir -p "$HOME/.config"
for d in alacritty tmux nvim zsh yabai skhd git; do
  ln -snf "$DOTFILES/$d" "$HOME/.config/$d"
done

# 3. ZDOTDIR
cat <<'EOF' > ~/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshenv"
EOF

# 4. Homebrew packages
brew bundle --file="$DOTFILES/Brewfile"

# 5. Oh My Zsh + autosuggestions
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.config/zsh/oh-my-zsh
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
  ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-autosuggestions

# 6. TPM
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 7. Fonts
brew install --cask font-jetbrains-mono-nerd-font
```

---

## Neovim

### Architecture

Targets **Neovim 0.12**. Uses native `vim.pack` for plugins, `vim.lsp.config`/`vim.lsp.enable` for language servers, and `blink.cmp` for completion. No profile system.

```
nvim/
  init.lua                  -- entry point: leader, core modules, LSP enable, startup screen
  nvim-pack-lock.json       -- vim.pack lock file (commit after updates)
  lua/
    core/
      options.lua           -- editor options
      keymaps.lua           -- global keymaps + LspAttach buffer keymaps
      autocmds.lua          -- autocommands (yank highlight, format-on-save, etc.)
      diagnostics.lua       -- diagnostic UI config
      format.lua            -- formatting (XML via xmllint, Erlang via erlfmt, else LSP)
      pack.lua              -- vim.pack.add() calls + plugin loading (immediate/deferred/lazy)
      util.lua              -- shared helpers
    plugins/                -- one file per plugin (config + keymaps)
      theme.lua  treesitter.lua  telescope.lua  gitsigns.lua  completion.lua (blink.cmp)
      which_key.lua  autopairs.lua  diffview.lua  neogit.lua  nvim_tree.lua
      render_markdown.lua  roslyn.lua  dap.lua  neotest.lua
    lsp/                    -- one file per language server (see table below)
    ui/
      intent.lua            -- startup "What are you here to do?" screen
  tests/                    -- focused Lua test scripts
```

### Plugin management

Uses native **`vim.pack`** (Neovim 0.12) — no `lazy.nvim`, no Mason; all external binaries are installed manually. All `vim.pack.add()` calls live in `lua/core/pack.lua`, split into immediate (first draw), deferred (`vim.schedule`), and filetype-lazy groups (roslyn on `cs`/`razor`, neotest on `go`/`cs`). Build steps (treesitter `TSUpdate`, `telescope-fzf-native` `make`, `blink.cmp` binary) run via `PackChanged` autocmd hooks. Plugins install on first launch; versions are pinned in `nvim-pack-lock.json`.

### EditorConfig

Neovim's built-in EditorConfig support is active. Global indentation in `options.lua` provides conservative defaults; per-project `.editorconfig` takes precedence.

### Formatting

Formatting runs **on save** for real file buffers. Manual trigger: `<leader>cf`.

- XML: uses `xmllint` (`brew install libxml2`)
- Erlang: uses `erlfmt` (ELP doesn't format)
- Everything else: LSP format

Routing lives in `lua/core/format.lua`.

### Language servers

All LSP servers are installed **explicitly** — Neovim does not download or manage them.

| Language       | Server                         | Install                                    |
|--------------- |------------------------------- |--------------------------------------------|
| Go             | gopls                          | `brew install gopls`                       |
| Rust           | rust-analyzer                  | `brew install rust-analyzer`               |
| TypeScript/JS  | typescript-language-server     | `npm i -g typescript typescript-language-server` |
| Angular        | @angular/language-server       | `npm i -g @angular/language-server`        |
| Bash/Zsh       | bash-language-server           | `npm i -g bash-language-server`            |
| JSON           | vscode-json-language-server    | `npm i -g vscode-langservers-extracted`    |
| YAML           | yaml-language-server           | `brew install yaml-language-server`        |
| TOML           | taplo                          | `brew install taplo`                       |
| Lua            | lua-language-server            | `brew install lua-language-server`         |
| Erlang         | elp (+ eqwalizer)              | Install [ELP](https://github.com/WhatsApp/erlang-language-platform); jar at `ELP_EQWALIZER_PATH` (see `.zshrc`) |
| C#             | Roslyn (via roslyn.nvim)       | Requires .NET SDK (see below)              |

Each server is one file under `lua/lsp/<name>.lua`. The active list is enabled in `init.lua` via `vim.lsp.enable` (servers whose binary isn't on `PATH` are skipped). Add a server by dropping a file in `lua/lsp/` and adding its name to that list.

### C# (Roslyn)

C# uses **Roslyn** via `seblyng/roslyn.nvim`. Requires the .NET SDK (`dotnet --info`). The Roslyn server payload is expected at `~/.local/share/lsp/roslyn/content/LanguageServer/osx-arm64/`.

### Debuggers (DAP)

| Language      | Adapter          | Install                                          |
|-------------- |----------------- |--------------------------------------------------|
| Go            | delve            | `brew install delve`                             |
| TypeScript/JS | vscode-js-debug  | Build locally (see below)                        |
| C#            | netcoredbg       | Build from source (see below)                    |

**vscode-js-debug:**
```sh
mkdir -p ~/.local/share/nvim/dap
cd ~/.local/share/nvim/dap
git clone --depth=1 https://github.com/microsoft/vscode-js-debug.git
cd vscode-js-debug
npm ci && npm run build
```

**netcoredbg (macOS arm64):**
```sh
brew install cmake ninja llvm
mkdir -p ~/Code/tools && cd ~/Code/tools
git clone https://github.com/Samsung/netcoredbg.git
cd netcoredbg && git checkout 3.1.3-1062
mkdir build && cd build
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$HOME/.local/netcoredbg"
ninja install
mkdir -p ~/.local/bin
ln -sf "$HOME/.local/netcoredbg/netcoredbg" "$HOME/.local/bin/netcoredbg"
```

### Testing (Neotest)

Neotest provides unified test execution for Go and .NET:

- `<leader>tn` — run nearest test
- `<leader>tf` — run file tests
- `<leader>ts` — run suite (`dotnet test src` when `src/` exists)
- `<leader>tS` — toggle summary panel
- `<leader>to` — open output window
- `<leader>tr` — re-run last test

Add .NET suite root overrides in `lua/plugins/neotest.lua`.

---

## Keybindings

### tmux

| Key                        | Action                    |
|--------------------------- |---------------------------|
| `Ctrl+Space`               | Prefix                    |
| `Alt+h/j/k/l`             | Focus pane                |
| `Alt+Shift+H/J/K/L`       | Resize pane               |
| `prefix+v`                 | Split horizontal          |
| `prefix+h`                 | Split vertical            |
| `prefix+f`                 | Session picker (fzf popup)|
| `prefix+C`                 | New session (prompt)      |
| `prefix+R`                 | Rename session            |

New panes/windows intentionally start in `$HOME`.

### Neovim

Leader is `Space`.

| Key              | Action                          |
|----------------- |---------------------------------|
| `<leader>w`      | Write buffer                    |
| `<leader>q` / `<leader>Q` | Quit window / quit all (force) |
| `<leader>bd` / `<leader>bD` | Close buffer / close all   |
| `<leader>cf`     | Format buffer                   |
| `<leader>ff`     | Find files (Telescope)          |
| `<leader>fg`     | Live grep (Telescope)           |
| `<leader><leader>` | Buffers (Telescope)           |
| `<leader>fh`     | Help (Telescope)                |
| `<leader>fb`     | File browser (nvim-tree)        |
| `]h` / `[h`      | Next/prev git hunk (gitsigns)   |
| `<leader>gd` / `<leader>gh` | Diffview toggle / file history |
| `<leader>gg`     | Neogit                          |
| `<leader>mr`     | Toggle markdown render          |
| `gd` / `grr` / `gri` | LSP definition / references / implementation |
| `grn` / `gra` / `K` / `<C-S>` | LSP rename / code action / hover / signature |
| `<leader>lR`     | Restart Roslyn (C# buffers)     |
| `[d` / `]d` / `<C-W>d` | Prev / next / float diagnostic |
| `<F5>`           | DAP continue                    |
| `<F10>/<F11>/<F12>` | DAP step over/into/out       |
| `<leader>db` / `<leader>dB` | Toggle / conditional breakpoint |
| `<leader>dr`     | DAP REPL                        |
| `Ctrl+h/j/k/l`   | Navigate vim/tmux panes         |

LSP and diagnostic navigation use Neovim 0.12 built-in defaults (`g r`-prefixed maps).

### zsh

| Key       | Action                           |
|---------- |----------------------------------|
| `p`       | Project picker (`cproj`)         |
| `Ctrl+P`  | Project picker widget            |

### yabai / skhd (macOS)

| Key                       | Action                    |
|-------------------------- |---------------------------|
| `Alt+h/j/k/l`            | Focus window              |
| `Shift+Alt+h/j/k/l`      | Move window               |
| `Ctrl+Alt+h/j/k/l`       | Resize window             |
| `Ctrl+Alt+e`             | Balance layout             |
| `Shift+Alt+Space`        | Toggle float + border      |
| `Alt+f`                  | Zoom fullscreen            |
| `Shift+Alt+f`            | macOS native fullscreen    |
| `Alt+Shift+1..5`         | Move window to space 1-5   |

**Note:** Space-movement keybindings (`Alt+Shift+1..5`) require the [yabai scripting addition](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition) to be enabled. You must also grant Accessibility permissions to yabai/skhd (System Settings → Privacy & Security → Accessibility).

---

## Security

- `gh/hosts.yml` is gitignored — `gh auth login` writes tokens into it. If a token ever gets committed, rotate it immediately and scrub git history.
- `.env` and `.env.local` are in the global gitignore.

---

## Health checks

```sh
# CLI tools
command -v nvim rg fd fzf gopls rust-analyzer lua-language-server dlv netcoredbg

# Neovim
nvim -c ':checkhealth'
```

---

## Maintenance

- Homebrew: `brew update && brew upgrade`
- Neovim plugins: `:lua vim.pack.update()` (commit the updated `nvim-pack-lock.json`)
- tmux plugins: `prefix + U`
- Add/remove LSP servers: add/remove a file in `lua/lsp/` and update the list in `init.lua`
- Add/remove DAP adapters: edit `lua/plugins/dap.lua`
