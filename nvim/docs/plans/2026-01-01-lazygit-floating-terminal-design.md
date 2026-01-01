# Lazygit Floating Terminal Design

## Overview
Add a `<leader>lg` keymap that opens `lazygit` inside a floating Neovim terminal window. This keeps lazygit inside the editor UI without extra plugins.

## Requirements
- Launch `lazygit` in a centered floating window.
- Clean up buffers and windows when lazygit exits.
- Notify if `lazygit` is not installed.
- Keep configuration minimal and native to Neovim.

## Approach
- Create a Lua helper `open_lazygit()` in the core config.
- On invocation, check `vim.fn.executable("lazygit")`.
- Create a scratch buffer (`nvim_create_buf(false, true)`) with `bufhidden=wipe`.
- Calculate size using `vim.o.columns`/`vim.o.lines` (80% width, 70% height), centered.
- Open a floating window via `nvim_open_win` with rounded border.
- Start `termopen("lazygit")` in the buffer and `startinsert`.
- Add a `TermClose` autocmd for the buffer to close the window and clean up.

## Error Handling
- If `lazygit` is missing, show `vim.notify` with an error level and return.

## Testing
- Manual: press `<leader>lg`, verify the float opens and closes cleanly.
- Confirm closing lazygit returns focus to the previous window with no stray buffers.

## Alternatives
- Use `kdheepak/lazygit.nvim` for a plugin-based UI, but this adds dependency weight.
