#!/bin/sh
# Prints "user@host | " only when the tmux client appears to be running under sshd.

# ===============================================================
# Resolve Client Process Tree
# ===============================================================
client_pid="$1" # tmux client PID from status-right
[ -z "$client_pid" ] && exit 0 # no PID provided

pid="$client_pid" # current PID in traversal

# ===============================================================
# Walk up the process tree until PID 1
# ===============================================================
while [ "$pid" -gt 1 ] 2>/dev/null; do
  comm="$(ps -o comm= -p "$pid" 2>/dev/null | awk '{print $1}')" # command name

  case "$comm" in
    sshd|sshd:*)
      # $USER is typically set; fall back to whoami if needed.
      u="${USER:-$(whoami)}" # username
      h="$(hostname -s 2>/dev/null || hostname 2>/dev/null)" # short hostname
      printf "#[fg=#768390]%s@%s#[fg=#768390] | " "$u" "$h" # render user@host
      exit 0
      ;;
  esac

  pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')" # parent PID
  [ -z "$pid" ] && exit 0 # stop if PPID not found
done

exit 0
