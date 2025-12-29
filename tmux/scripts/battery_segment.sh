#!/bin/sh
# Prints:
# - "87% | " or "87% (Charging) | " on macOS (pmset)
# - Similar on Linux if upower is available
# - Nothing if battery info is unavailable

# ===============================================================
# macOS (pmset)
# ===============================================================
if command -v pmset >/dev/null 2>&1; then
  line="$(pmset -g batt 2>/dev/null | awk '/InternalBattery/ {print; exit}')" # first battery line
  [ -z "$line" ] && exit 0 # no battery information

  pct="$(printf "%s\n" "$line" | awk '{gsub(/;/,"",$3); print $3}')" # percentage
  state="$(printf "%s\n" "$line" | awk '{gsub(/;/,"",$4); print $4}')" # charging state

  if [ "$state" = "charging" ]; then
    printf "#[fg=#c69026]%s (Charging)#[fg=#768390] | " "$pct" # highlight charging
  else
    printf "#[fg=#c69026]%s#[fg=#768390] | " "$pct" # normal battery output
  fi
  exit 0
fi

# ===============================================================
# Linux (upower)
# ===============================================================
if command -v upower >/dev/null 2>&1; then
  dev="$(upower -e 2>/dev/null | grep -m1 battery || true)" # first battery device
  [ -z "$dev" ] && exit 0 # no battery device

  pct="$(upower -i "$dev" 2>/dev/null | awk -F': *' '/percentage/ {print $2; exit}')" # percentage
  state="$(upower -i "$dev" 2>/dev/null | awk -F': *' '/state/ {print $2; exit}')" # charging state
  [ -z "$pct" ] && exit 0 # missing percentage

  if [ "$state" = "charging" ]; then
    printf "%s (Charging) | " "$pct" # linux charging output
  else
    printf "%s | " "$pct" # linux normal output
  fi
  exit 0
fi

exit 0
