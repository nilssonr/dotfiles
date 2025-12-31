# ===============================================================
# Oh My Zsh
# ===============================================================
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZSH="$ZDOTDIR/oh-my-zsh"

# Keep the theme simple; we'll override the prompt after OMZ loads.
ZSH_THEME="robbyrussell"

# Minimal plugins only
plugins=(git fzf zsh-autosuggestions)

# Load OMZ
source "$ZSH/oh-my-zsh.sh"

# ===============================================================
# Prompt refresh (ensure git status updates immediately on cd)
# ===============================================================
setopt PROMPT_SUBST

autoload -Uz add-zsh-hook

# When directory changes, refresh prompt immediately (covers widgets too)
function _refresh_prompt_on_chpwd() {
  # Only runs in interactive shells; zle exists only then.
  if (( $+functions[zle] )); then
    zle reset-prompt 2>/dev/null || true
  fi
}
add-zsh-hook chpwd _refresh_prompt_on_chpwd


# ===============================================================
# Environment
# ===============================================================

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# local bin
export PATH="$HOME/.local/bin:$PATH"

# go bin
export PATH="$(go env GOPATH)/bin:$PATH"

# Corepack: suppress download prompt
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# fnm (Fast Node Manager)
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ===============================================================
# Prompt — GitHub Dark Dimmed (text-only)
# Must be AFTER OMZ is sourced, otherwise theme overrides it.
# ===============================================================

# Git segment styling (used by git_prompt_info from OMZ)
ZSH_THEME_GIT_PROMPT_PREFIX='%F{red}('
ZSH_THEME_GIT_PROMPT_SUFFIX=')%f '
ZSH_THEME_GIT_PROMPT_DIRTY='%F{yellow}*%f'
ZSH_THEME_GIT_PROMPT_CLEAN=''

# Prompt:
# - blue current path (%~)
# - git branch if in repo
# - right-pointing caret
PROMPT='%F{blue}%~%f $(git_prompt_info)› '

# Optional: show a red prompt path when last command failed (uncomment if desired)
# PROMPT='%(?.%F{blue}%~.%F{red}%~)%f $(git_prompt_info)› '

# ===============================================================
# ls colors (macOS, GitHub Dark Dimmed–friendly)
# ===============================================================

# Directories: blue
# Symlinks: cyan
# Executables: green
# Everything else: default
export LSCOLORS="exfxcxdxbxegedabagacad"

# ===============================================================
# Aliases (minimal)
# ===============================================================
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias lg='lazygit'
alias k='kubectl'
alias kx='kubectx'
alias vim='nvim'

# ===============================================================
# Project picker (fzf)
# - Workspace roots: ~/Code/*
# - Repos: one level down (~/Code/<root>/<repo>)
# ===============================================================

# Internal: print a selected "root/repo" to stdout (or nothing if canceled).
function _cproj_select() {
  local -a candidates
  candidates=()

  local root
  for root in "$HOME"/Code/*; do
    [[ -d "$root" ]] || continue
    while IFS= read -r -d '' dir; do
      candidates+=("$dir")
    done < <(find "$root" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
  done

  (( ${#candidates[@]} == 0 )) && return 1

  # Show as "workspace/repo"
  printf '%s\n' "${candidates[@]}" \
    | sed "s|^$HOME/Code/||" \
    | fzf --prompt='project> ' --no-sort --tiebreak=index
}

# Command form: type `cproj` then Enter
function cproj() {
  local selected
  selected="$(_cproj_select)" || return 0
  cd "$HOME/Code/$selected" || return 1
}

alias p='cproj'

# Widget form: Ctrl-P (updates prompt immediately)
function _cproj_widget() {
  local selected
  selected="$(_cproj_select)" || { zle reset-prompt; return 0; }

  cd "$HOME/Code/$selected" || { zle reset-prompt; return 1; }

  # Clear current editing line and redraw prompt in the new directory
  BUFFER=""
  CURSOR=0
  zle reset-prompt
}

zle -N _cproj_widget
bindkey '^P' _cproj_widget

# ===============================================================
# Completion menu colors (Tab list) — make directories blue
# ===============================================================
zmodload -i zsh/complist

# zsh uses GNU dircolors-style codes here:
# di=34 (blue), ln=36 (cyan), ex=32 (green)
zstyle ':completion:*' list-colors 'di=34:ln=36:ex=32'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
