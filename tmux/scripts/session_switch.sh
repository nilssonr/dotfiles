#!/bin/sh
set -eu # exit on error or unset variable

# ===============================================================
# Session Picker (fzf)
# ===============================================================
# Capture query + selection; fzf prints query on line 1 and selection on line 3.
out="$(
  # List sessions by name only.
  tmux list-sessions -F '#{session_name}' 2>/dev/null \
  | fzf --reverse --prompt='session> ' \
        --print-query --expect=enter \
        --preview 'tmux capture-pane -ep -t {} 2>/dev/null | tail -200'
)" || exit 0 # exit cleanly if fzf is cancelled

# ===============================================================
# Parse Selection
# ===============================================================
query="$(printf "%s\n" "$out" | sed -n '1p')" # fzf query text
picked="$(printf "%s\n" "$out" | sed -n '3p')" # chosen session

name="${picked:-$query}" # prefer selection; fallback to query
# Trim whitespace
name="$(printf "%s" "$name" | awk '{$1=$1;print}')" # normalize whitespace
[ -z "$name" ] && exit 0 # no name means no action

# ===============================================================
# Switch or Create Session
# ===============================================================
if tmux has-session -t "$name" 2>/dev/null; then
  tmux switch-client -t "$name" # switch to existing session
else
  tmux new-session -d -s "$name" # create session in background
  tmux switch-client -t "$name" # switch to new session
fi
