cat <<'EOF' > ~/.config/nvim/README.md
# Neovim Configuration (Lua, Lazy, Explicit Tooling)

This Neovim configuration is designed to be:

- **Explicit**: no Mason, no auto-downloaded binaries
- **Reproducible**: every external dependency is documented
- **Maintainable**: no god files, table-driven configuration
- **Scoped**: stable profile + experimental profiles
- **Text-only UI**: no icons, no italics
- **Consistent** with terminal tooling (tmux, zsh, GitHub Dark Dimmed)

**Target version:** Neovim v0.11.5

---

## Directory Layout

~/.config/nvim/
  init.lua
  README.md
  lua/
    core/
      profile.lua
      lazy.lua
      options.lua
      keymaps.lua
      autocmds.lua
      diagnostics.lua
      util.lua
    profiles/
      stable/
        init.lua
        plugins/
          editorconfig.lua
          theme.lua
          which_key.lua
          telescope.lua
          completion.lua
          lsp.lua
          roslyn.lua
          dap.lua
      lab/
        init.lua
        plugins/
          README.md

---

## Profiles

- **stable** (default): day-to-day work
- **lab**: empty sandbox for experimentation

Run a different profile with:

NVIM_PROFILE=lab nvim

---

## Plugin Management

- Uses **lazy.nvim**
- No Mason
- Plugins are declared per profile
- External binaries are installed manually

lazy.nvim bootstraps itself on first run.

---

## EditorConfig

This configuration respects `.editorconfig` via:

editorconfig/editorconfig-vim

Global indentation settings are conservative defaults only.
Per-project indentation is controlled by `.editorconfig`.

---

## Required CLI Tools

### Core Utilities

brew install ripgrep fd fzf

---

## Language Servers (LSP)

All LSP servers are installed **explicitly**.
Neovim does not download or manage language servers.

### Go

brew install gopls

### Rust

brew install rust-analyzer

### TypeScript / JavaScript

npm i -g typescript typescript-language-server

### JSON

npm i -g vscode-json-languageserver

### YAML

brew install yaml-language-server

### TOML

brew install taplo

### XML

brew install lemminx

---

## C# Language Server

C# uses **Roslyn** via:

seblyng/roslyn.nvim

Requires the .NET SDK.

Verify:

dotnet --info | head -n 5

---

## Debuggers (DAP)

### Go (Delve)

brew install delve

---

### TypeScript / JavaScript (Node)

Uses **vscode-js-debug**, built locally:

mkdir -p ~/.local/share/nvim/dap
cd ~/.local/share/nvim/dap
git clone --depth=1 https://github.com/microsoft/vscode-js-debug.git
cd vscode-js-debug
npm ci
npm run build

---

## C# Debugger (netcoredbg) — macOS arm64

netcoredbg is not available in Homebrew core and has no reliable
prebuilt macOS arm64 binary. It is built from source.

### Prerequisites

brew install cmake ninja llvm
xcode-select --install

### Build and Install

mkdir -p ~/Code/tools
cd ~/Code/tools
git clone https://github.com/Samsung/netcoredbg.git
cd netcoredbg
git checkout 3.1.3-1062

# Patch src/CMakeLists.txt to expand managed/*.cs and ncdbhook/*.cs
# (Ninja does not expand wildcards in DEPENDS)

rm -rf build
mkdir build
cd build
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$HOME/.local/netcoredbg"
ninja install

### Expose Binary on PATH

mkdir -p ~/.local/bin
ln -sf "$HOME/.local/netcoredbg/netcoredbg" "$HOME/.local/bin/netcoredbg"
chmod +x "$HOME/.local/netcoredbg/netcoredbg"

Verify:

netcoredbg --version

---

## Health Checks

### Shell

command -v nvim rg fd fzf
command -v gopls rust-analyzer
command -v node
command -v dlv netcoredbg

### Neovim

:checkhealth

---

## Formatting

Formatting is **manual by default**:

<leader>f

No format-on-save unless explicitly enabled.

---

## Maintenance Notes

- Add/remove LSP servers by editing a single table in:
  lua/profiles/stable/plugins/lsp.lua

- Add/remove DAP adapters by editing:
  lua/profiles/stable/plugins/dap.lua

- Experiment safely in:
  lua/profiles/lab/

This configuration is intentionally boring, explicit, and durable.
EOF

