# Keep every PATH/fpath entry once, so nested shells (tmux panes are login
# shells that inherit PATH and re-run path_helper) don't pile up duplicates.
typeset -U path fpath

export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZSH="$ZDOTDIR/oh-my-zsh"
ZSH_CACHE_DIR="$ZSH/cache"

# History. Not exported: an exported HISTFILE leaks into bash subshells,
# which then write bash-format history into the zsh file.
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# Environment / PATH
export EDITOR=nvim
export VISUAL=nvim
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
# Suppress Corepack interactive download prompt
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# Homebrew llvm comes first on purpose: clang, clang++, clangd and dsymutil
# resolve to Homebrew's llvm, not Apple's Xcode toolchain.
# GOPATH default is used directly to avoid forking `go env` on every start.
path=(
  "$BUN_INSTALL/bin"
  /opt/homebrew/opt/llvm/bin(N)
  "${GOPATH:-$HOME/go}/bin"
  "$HOME/.local/share/bob/nvim-bin"
  "$HOME/.local/bin"
  "$HOME/.dotnet/tools"
  "$PNPM_HOME"
  "$HOME/.cargo/bin"
  $path
)

# Write a generator command's output to <file>, regenerating it only when
# <binary> (symlinks resolved) is newer than the file. Sets REPLY to <file>.
# A failed run leaves <file>.failed so the command isn't retried on every
# shell start, only after <binary> changes.
# Usage: _zsh_cache <file> <binary> <cmd...>
_zsh_cache() {
  local file=$1 bin=${2:A}
  shift 2
  REPLY=$file
  [[ -s $file && ! $bin -nt $file ]] && return 0
  [[ -e $file.failed && ! $bin -nt $file.failed ]] && return 1
  mkdir -p "${file:h}"
  if "$@" >| "$file.tmp" 2>/dev/null && [[ -s $file.tmp ]]; then
    mv -f "$file.tmp" "$file"
    rm -f "$file.failed"
  else
    rm -f "$file.tmp"
    : >| "$file.failed"
    return 1
  fi
}

# fnm: before Oh My Zsh so node-installed tools (codex) are on PATH for the
# completion generation below.
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Generated completions go into Oh My Zsh's cache completions dir, which it
# puts on fpath before running compinit.
if (( $+commands[codex] )); then
  _zsh_cache "$ZSH_CACHE_DIR/completions/_codex" "$commands[codex]" codex completion zsh
fi

# Oh My Zsh. ZSH_THEME is empty because PROMPT is set below; this is the
# only compinit call.
ZSH_THEME=""
plugins=(git zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

# fzf key bindings (Ctrl-R, Ctrl-T, Alt-C) and completion, cached instead of
# running `fzf --zsh` on every start.
if (( $+commands[fzf] )) && _zsh_cache "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf.zsh" "$commands[fzf]" fzf --zsh; then
  source "$REPLY"
fi

# bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Prompt. git_prompt_info comes from Oh My Zsh's lib/git.zsh.
ZSH_THEME_GIT_PROMPT_PREFIX='%F{red}('
ZSH_THEME_GIT_PROMPT_SUFFIX=')%f '
ZSH_THEME_GIT_PROMPT_DIRTY='%F{yellow}*%f'
ZSH_THEME_GIT_PROMPT_CLEAN=''

PROMPT='%F{blue}%~%f $(git_prompt_info)› '

# ls colors: directories blue, symlinks cyan, executables green
export LSCOLORS="exfxcxdxbxegedabagacad"
zstyle ':completion:*' list-colors 'di=34:ln=36:ex=32'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

# Aliases. `..` and `...` are left to Oh My Zsh (auto_cd plus its global
# alias `...` = ../..).
alias ll='ls -lah'
alias lg='lazygit'
alias k='kubectl'
alias kx='kubectx'
alias kns='kubens'
alias vim='nvim'

# Claude launchers. An optional first arg that doesn't start with '-' is a
# session name, recorded in OTEL_RESOURCE_ATTRIBUTES.
# Usage: agent [session-name] [claude-flags...]
#        poirot [session-name] [claude-flags...]
# Internal: _claude_run <otel-agent> [claude-args...] -- [session-name] [flags...]
_claude_run() {
  local otel_attrs="agent=$1"
  shift
  local -a pre=()
  while (( $# )) && [[ $1 != -- ]]; do
    pre+=("$1")
    shift
  done
  (( $# )) && shift
  if [[ -n ${1:-} && $1 != -* ]]; then
    otel_attrs+=",session_name=${1// /_}"
    shift
  fi
  OTEL_RESOURCE_ATTRIBUTES="$otel_attrs" \
    claude "${pre[@]}" --plugin-dir ~/Code/nilssonr/claude-ops --dangerously-skip-permissions "$@"
}
agent()  { _claude_run claude -- "$@" }
poirot() { _claude_run poirot --agent claude-ops:hercule-poirot -- "$@" }

# Project picker: repos one level under ~/Code/*/
_cproj_select() {
  local -a dirs=("$HOME"/Code/*/*(N/))
  (( $#dirs )) || return 1
  print -rl -- "${dirs[@]#$HOME/Code/}" \
    | fzf --prompt='project> ' --no-sort --tiebreak=index
}

cproj() {
  local selected
  selected="$(_cproj_select)" || return 0
  cd "$HOME/Code/$selected" || return 1
}

alias p='cproj'

# Widget form, bound to Ctrl-P (replaces the default up-line-or-history).
# Redraws the prompt after cd so the new directory and git status show.
_cproj_widget() {
  local selected
  selected="$(_cproj_select)" || { zle reset-prompt; return 0; }

  cd "$HOME/Code/$selected" || { zle reset-prompt; return 1; }

  BUFFER=""
  CURSOR=0
  zle reset-prompt
}

zle -N _cproj_widget
bindkey '^P' _cproj_widget

# eqWAlizer JAR for ELP. Without ELP_EQWALIZER_PATH every elp run extracts
# its embedded ~10 MB jar into $TMPDIR and leaves it there (a day of gates
# left 21 copies). With the variable set, elp uses that file instead, but it
# MUST match the installed elp: an older jar dies with a JSON "illegal
# discriminator" error on every module. So the override is exported only
# while the jar is newer than the elp binary. After
# `brew upgrade erlang-language-platform`, run `elp-eqwalizer-sync`, which
# pulls the embedded jar straight out of the new binary.
elp-eqwalizer-sync() {
  local jar="$HOME/.local/share/eqwalizer.jar" elp
  elp="$(readlink -f "$(command -v elp)")" || { echo "elp not installed" >&2; return 1; }
  # brew installs a wrapper script in bin/; the binary is in libexec/.
  [[ -f "${elp:h}/../libexec/elp" ]] && elp="${elp:h}/../libexec/elp"
  mkdir -p "${jar:h}"
  python3 - "$elp" "$jar" <<'PY' || return 1
import io, struct, sys, zipfile
elp, out = sys.argv[1], sys.argv[2]
data = open(elp, "rb").read()
pos = 0
while (eocd := data.find(b"PK\x05\x06", pos)) >= 0:
    pos = eocd + 4
    cd_size, cd_offset, comment = struct.unpack("<IIH", data[eocd + 12:eocd + 22])
    start, end = eocd - cd_size - cd_offset, eocd + 22 + comment
    if start < 0 or data[start:start + 2] != b"PK":
        continue
    blob = data[start:end]
    try:
        with zipfile.ZipFile(io.BytesIO(blob)) as z:
            if b"com.whatsapp.eqwalizer.Main" in z.read("META-INF/MANIFEST.MF"):
                open(out, "wb").write(blob)
                sys.exit(0)
    except (zipfile.BadZipFile, KeyError):
        continue
sys.exit("no eqwalizer jar found in " + elp)
PY
  export ELP_EQWALIZER_PATH="$jar"
  echo "eqwalizer jar synced from $elp"
}
if (( $+commands[elp] )); then
  if [[ "$HOME/.local/share/eqwalizer.jar" -nt "${commands[elp]:A}" ]]; then
    export ELP_EQWALIZER_PATH="$HOME/.local/share/eqwalizer.jar"
  else
    echo "elp: eqwalizer jar missing or older than elp, run elp-eqwalizer-sync" >&2
  fi
fi
