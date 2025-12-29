#!/bin/sh
# Prints:
# - "87% | " or "87% (Charging) | " on macOS (pmset)
# - Similar on Linux if upower is available
# - Nothing if battery info is unavailable

# macOS
if command -v pmset >/dev/null 2>&1; then
  line="$(pmset -g batt 2>/dev/null | awk '/InternalBattery/ {print; exit}')"
  [ -z "$line" ] && exit 0

  pct="$(printf "%s\n" "$line" | awk '{gsub(/;/,"",$3); print $3}')"
  state="$(printf "%s\n" "$line" | awk '{gsub(/;/,"",$4); print $4}')"

  if [ "$state" = "charging" ]; then
    printf "#[fg=#c69026]%s (Charging)#[fg=#768390] | " "$pct"
  else
    printf "#[fg=#c69026]%s#[fg=#768390] | " "$pct"
  fi
  exit 0
fi

# Linux (optional)
if command -v upower >/dev/null 2>&1; then
  dev="$(upower -e 2>/dev/null | grep -m1 battery || true)"
  [ -z "$dev" ] && exit 0

  pct="$(upower -i "$dev" 2>/dev/null | awk -F': *' '/percentage/ {print $2; exit}')"
  state="$(upower -i "$dev" 2>/dev/null | awk -F': *' '/state/ {print $2; exit}')"
  [ -z "$pct" ] && exit 0

  if [ "$state" = "charging" ]; then
    printf "%s (Charging) | " "$pct"
  else
    printf "%s | " "$pct"
  fi
  exit 0
fi

exit 0

