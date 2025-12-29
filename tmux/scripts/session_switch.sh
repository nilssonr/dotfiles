#!/bin/sh
set -eu

# List sessions; let user type arbitrary query
out="$(
  tmux list-sessions -F '#{session_name}' 2>/dev/null \
  | fzf --reverse --prompt='session> ' \
        --print-query --expect=enter \
        --preview 'tmux capture-pane -ep -t {} 2>/dev/null | tail -200'
)" || exit 0

query="$(printf "%s\n" "$out" | sed -n '1p')"
picked="$(printf "%s\n" "$out" | sed -n '3p')"

name="${picked:-$query}"
# Trim whitespace
name="$(printf "%s" "$name" | awk '{$1=$1;print}')"
[ -z "$name" ] && exit 0

if tmux has-session -t "$name" 2>/dev/null; then
  tmux switch-client -t "$name"
else
  tmux new-session -d -s "$name"
  tmux switch-client -t "$name"
fi

