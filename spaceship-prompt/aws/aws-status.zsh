#
# Amazon Web Services (AWS)
#
# The AWS Command Line Interface (CLI) is a unified tool to manage AWS services.
# Link: https://aws.amazon.com/cli/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_AWS_STATUS_SHOW="${SPACESHIP_AWS_STATUS_SHOW=true}"
SPACESHIP_AWS_STATUS_ASYNC="${SPACESHIP_AWS_STATUS_ASYNC=true}"
SPACESHIP_AWS_STATUS_PREFIX="${SPACESHIP_AWS_STATUS_PREFIX=}"
SPACESHIP_AWS_STATUS_SUFFIX="${SPACESHIP_AWS_STATUS_SUFFIX="$"}"
SPACESHIP_AWS_STATUS_SYMBOL="${SPACESHIP_AWS_STATUS_SYMBOL="\uf0ef  "}"

SPACESHIP_AWS_STATUS_USE_CLI="${SPACESHIP_AWS_STATUS_USE_CLI=false}"
SPACESHIP_AWS_STATUS_CACHE="${SPACESHIP_AWS_STATUS_CACHE=false}"
SPACESHIP_AWS_STATUS_CACHE_TIMEOUT="${SPACESHIP_AWS_STATUS_CACHE_TIMEOUT=3600}"
SPACESHIP_AWS_STATUS_CONNECTED_COLOR="${SPACESHIP_AWS_STATUS_CONNECTED_COLOR=green}"
SPACESHIP_AWS_STATUS_DISCONNECTED_COLOR="${SPACESHIP_AWS_STATUS_DISCONNECTED_COLOR=red}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

function get_aws_status_color() {
  if [[ "$SPACESHIP_AWS_STATUS_USE_CLI" == false ]]; then
    echo $SPACESHIP_AWS_STATUS_CONNECTED_COLOR
    return
  fi

  local tmp_dir="${promptDir}/tmp"
  mkdir -p "$tmp_dir"
  local cache_file="${tmp_dir}/spaceship_aws_status"

  if [[ "$SPACESHIP_AWS_STATUS_CACHE" == true ]]; then
    if [[ -f "$cache_file" && $(($(date +%s) - $(stat -f %m "$cache_file"))) -lt $SPACESHIP_AWS_STATUS_CACHE_TIMEOUT ]]; then
      cat "$cache_file"
      return
    fi
  fi

  local active_account=$(aws sts get-caller-identity 2>/dev/null)
  if [[ -n "$active_account" ]]; then
    echo $SPACESHIP_AWS_STATUS_CONNECTED_COLOR | tee "$cache_file" 2>/dev/null
  else
    echo $SPACESHIP_AWS_STATUS_DISCONNECTED_COLOR | tee "$cache_file" 2>/dev/null
  fi
}

spaceship_aws_status() {
  [[ $SPACESHIP_AWS_STATUS_SHOW == false ]] && return

  spaceship::exists aws || return

  local profile=${AWS_VAULT:-$AWS_PROFILE}

  [[ -z $profile ]] || [[ "$profile" == "default" ]] && return

  local aws_status_color=$(get_aws_status_color)

  spaceship::section \
    --color "$aws_status_color" \
    --prefix "$SPACESHIP_AWS_STATUS_PREFIX" \
    --suffix "$SPACESHIP_AWS_STATUS_SUFFIX" \
    --symbol "$SPACESHIP_AWS_STATUS_SYMBOL" \
    "$profile"
}
