# Angular Language Server Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add Angular language server config to Neovim that only activates in Angular projects and passes ngserver probe locations based on the detected root.

**Architecture:** Register a new `angularls` config in `core.lsp` with Angular root markers and a `cmd` function that builds the `ngserver` command using `root_dir` for `--tsProbeLocations` and `--ngProbeLocations`. Add a small headless Neovim test script that asserts the config exists and has the expected markers and cmd type.

**Tech Stack:** Neovim 0.11 built-in LSP, Lua config, headless `nvim`.

### Task 1: Add angularls config and headless test (@superpowers:test-driven-development)

**Files:**
- Create: `nvim/tests/angular_lsp.lua`
- Modify: `nvim/lua/core/lsp.lua`

**Step 1: Write the failing test**

```lua
-- nvim/tests/angular_lsp.lua
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root .. "/nvim")
require("core.lsp").setup()

local cfg = vim.lsp.config.angularls
assert(cfg, "angularls config missing")

local markers = cfg.root_markers or {}
local function has(marker)
  for _, item in ipairs(markers) do
    if item == marker then
      return true
    end
  end
  return false
end

assert(has("angular.json"), "angular.json root marker missing")
assert(has("project.json"), "project.json root marker missing")
assert(type(cfg.cmd) == "function", "angularls cmd should be a function")
```

**Step 2: Run test to verify it fails**

Run: `nvim --headless -u NONE -c "lua dofile('nvim/tests/angular_lsp.lua')" -c "qa"`

Expected: FAIL with "angularls config missing"

**Step 3: Write minimal implementation**

```lua
-- nvim/lua/core/lsp.lua (inside servers table)
angularls = {
  cmd = function(dispatchers, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    local cmd = {
      "ngserver",
      "--stdio",
      "--tsProbeLocations",
      root_dir,
      "--ngProbeLocations",
      root_dir,
    }
    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
  end,
  filetypes = { "typescript", "typescriptreact", "html" },
  root_markers = { "angular.json", "project.json" },
  workspace_required = true,
},
```

**Step 4: Run test to verify it passes**

Run: `nvim --headless -u NONE -c "lua dofile('nvim/tests/angular_lsp.lua')" -c "qa"`

Expected: PASS (exit 0, no output)

**Step 5: Commit**

```bash
git add nvim/tests/angular_lsp.lua nvim/lua/core/lsp.lua
git commit -m "feat(nvim): add angular language server config"
```
