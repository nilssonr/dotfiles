#!/bin/sh
# Prints "user@host | " only when the tmux client appears to be running under sshd.

client_pid="$1"
[ -z "$client_pid" ] && exit 0

pid="$client_pid"

while [ "$pid" -gt 1 ] 2>/dev/null; do
  comm="$(ps -o comm= -p "$pid" 2>/dev/null | awk '{print $1}')"

  case "$comm" in
    sshd|sshd:*)
      # $USER is typically set; fall back to whoami if needed.
      u="${USER:-$(whoami)}"
      h="$(hostname -s 2>/dev/null || hostname 2>/dev/null)"
      printf "#[fg=#768390]%s@%s#[fg=#768390] | " "$u" "$h"
      exit 0
      ;;
  esac

  pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"
  [ -z "$pid" ] && exit 0
done

exit 0

