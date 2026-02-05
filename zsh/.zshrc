# Oh My Zsh
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZSH="$ZDOTDIR/oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git fzf zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

# Refresh prompt on directory change so git status updates immediately
setopt PROMPT_SUBST

autoload -Uz add-zsh-hook

function _refresh_prompt_on_chpwd() {
  if (( $+functions[zle] )); then
    zle reset-prompt 2>/dev/null || true
  fi
}
add-zsh-hook chpwd _refresh_prompt_on_chpwd

# Environment / PATH
export EDITOR=nvim
export VISUAL=nvim

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.local/bin:$PATH"

# Avoid forking `go env` on every shell start
export PATH="${GOPATH:-$HOME/go}/bin:$PATH"

# Suppress Corepack interactive download prompt
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Prompt — must be AFTER OMZ is sourced, otherwise the theme overrides it
ZSH_THEME_GIT_PROMPT_PREFIX='%F{red}('
ZSH_THEME_GIT_PROMPT_SUFFIX=')%f '
ZSH_THEME_GIT_PROMPT_DIRTY='%F{yellow}*%f'
ZSH_THEME_GIT_PROMPT_CLEAN=''

PROMPT='%F{blue}%~%f $(git_prompt_info)› '

# ls colors: directories blue, symlinks cyan, executables green
export LSCOLORS="exfxcxdxbxegedabagacad"

# Aliases
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias lg='lazygit'
alias k='kubectl'
alias kx='kubectx'
alias kns='kubens'
alias vim='nvim'

# Project picker — lists repos one level under ~/Code/*/
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

  printf '%s\n' "${candidates[@]}" \
    | sed "s|^$HOME/Code/||" \
    | fzf --prompt='project> ' --no-sort --tiebreak=index
}

function cproj() {
  local selected
  selected="$(_cproj_select)" || return 0
  cd "$HOME/Code/$selected" || return 1
}

alias p='cproj'

# Widget form (Ctrl-P) — updates prompt immediately after cd
function _cproj_widget() {
  local selected
  selected="$(_cproj_select)" || { zle reset-prompt; return 0; }

  cd "$HOME/Code/$selected" || { zle reset-prompt; return 1; }

  BUFFER=""
  CURSOR=0
  zle reset-prompt
}

zle -N _cproj_widget
bindkey '^P' _cproj_widget

# Completion
zmodload -i zsh/complist
zstyle ':completion:*' list-colors 'di=34:ln=36:ex=32'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
[ -d /opt/homebrew/opt/llvm ] && export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

fpath=(./completions $fpath)
autoload -Uz compinit
compinit
