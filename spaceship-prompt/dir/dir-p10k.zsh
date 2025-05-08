#
# Working directory
#
# Current directory. Return only three last items of path

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_DIR_P10K_SHOW="${SPACESHIP_DIR_P10K_SHOW=true}"
SPACESHIP_DIR_P10K_PREFIX="${SPACESHIP_DIR_P10K_PREFIX=}"
SPACESHIP_DIR_P10K_SUFFIX="${SPACESHIP_DIR_P10K_SUFFIX=" "}"
SPACESHIP_DIR_P10K_TRUNC="${SPACESHIP_DIR_P10K_TRUNC=3}"
SPACESHIP_DIR_P10K_TRUNC_PREFIX="${SPACESHIP_DIR_P10K_TRUNC_PREFIX=}"
SPACESHIP_DIR_P10K_TRUNC_REPO="${SPACESHIP_DIR_P10K_TRUNC_REPO=true}"
SPACESHIP_DIR_P10K_COLOR="${SPACESHIP_DIR_P10K_COLOR=39}"
SPACESHIP_DIR_P10K_LOCK_SYMBOL="${SPACESHIP_DIR_P10K_LOCK_SYMBOL="\uf456 "}"
SPACESHIP_DIR_P10K_LOCK_COLOR="${SPACESHIP_DIR_P10K_LOCK_COLOR="red"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_dir_p10k() {
  [[ $SPACESHIP_DIR_P10K_SHOW == false ]] && return

  local dir trunc_prefix

  # Threat repo root as a top-level directory or not
  if [[ $SPACESHIP_DIR_P10K_TRUNC_REPO == true ]] && spaceship::is_git; then
    local git_root=$(git rev-parse --show-toplevel)

    if (cygpath --version) >/dev/null 2>/dev/null; then
      git_root=$(cygpath -u $git_root)
    fi

    # Check if the parent of the $git_root is "/"
    if [[ $git_root:h == / ]]; then
      trunc_prefix=/
    else
      trunc_prefix=$SPACESHIP_DIR_P10K_TRUNC_PREFIX
    fi

    # `${NAME#PATTERN}` removes a leading prefix PATTERN from NAME.
    # `$~~` avoids `GLOB_SUBST` so that `$git_root` won't actually be
    # considered a pattern and matched literally, even if someone turns that on.
    # `$git_root` has symlinks resolved, so we use `${PWD:A}` which resolves
    # symlinks in the working directory.
    # See "Parameter Expansion" under the Zsh manual.
    dir="$trunc_prefix$git_root:t${${PWD:A}#$~~git_root}"
  else
    if [[ SPACESHIP_DIR_P10K_TRUNC -gt 0 ]]; then
      # `%(N~|TRUE-TEXT|FALSE-TEXT)` replaces `TRUE-TEXT` if the current path,
      # with prefix replacement, has at least N elements relative to the root
      # directory else `FALSE-TEXT`.
      # See "Prompt Expansion" under the Zsh manual.
      trunc_prefix="%($((SPACESHIP_DIR_P10K_TRUNC + 1))~|$SPACESHIP_DIR_P10K_TRUNC_PREFIX|)"
    fi

    dir="$trunc_prefix%${SPACESHIP_DIR_P10K_TRUNC}~"
  fi

  local prefix="$SPACESHIP_DIR_P10K_PREFIX"

  if [[ ! -w . ]]; then
    prefix="%F{$SPACESHIP_DIR_P10K_LOCK_COLOR}${SPACESHIP_DIR_P10K_LOCK_SYMBOL}%f${SPACESHIP_DIR_P10K_PREFIX}"
  fi

  spaceship::section \
    --color "$SPACESHIP_DIR_P10K_COLOR" \
    --prefix "$prefix" \
    --suffix "$SPACESHIP_DIR_P10K_SUFFIX" \
    "$dir"
}
