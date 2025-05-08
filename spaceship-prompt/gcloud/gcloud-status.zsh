#
# Google Cloud Platform (gcloud)
#
# gcloud is a tool that provides the primary command-line interface to Google Cloud Platform.
# Link: https://cloud.google.com/sdk/gcloud/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GCLOUD_STATUS_SHOW="${SPACESHIP_GCLOUD_STATUS_SHOW=true}"
SPACESHIP_GCLOUD_STATUS_ASYNC="${SPACESHIP_GCLOUD_STATUS_ASYNC=true}"
SPACESHIP_GCLOUD_STATUS_PREFIX="${SPACESHIP_GCLOUD_STATUS_PREFIX=}"
SPACESHIP_GCLOUD_STATUS_SUFFIX="${SPACESHIP_GCLOUD_STATUS_SUFFIX=" "}"
SPACESHIP_GCLOUD_STATUS_SYMBOL="${SPACESHIP_GCLOUD_STATUS_SYMBOL="\uf1a0 "}"

SPACESHIP_GCLOUD_STATUS_USE_CLI="${SPACESHIP_GCLOUD_STATUS_USE_CLI=false}"
SPACESHIP_GCLOUD_STATUS_CACHE="${SPACESHIP_GCLOUD_STATUS_CACHE=false}"
SPACESHIP_GCLOUD_STATUS_CACHE_TIMEOUT="${SPACESHIP_GCLOUD_STATUS_CACHE_TIMEOUT=3600}"
SPACESHIP_GCLOUD_STATUS_CONNECTED_COLOR="${SPACESHIP_GCLOUD_STATUS_CONNECTED_COLOR=green}"
SPACESHIP_GCLOUD_STATUS_DISCONNECTED_COLOR="${SPACESHIP_GCLOUD_STATUS_DISCONNECTED_COLOR=red}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

function get_gcloud_status_color() {
  local active_account="$1"

  if [[ "$SPACESHIP_GCLOUD_STATUS_USE_CLI" == false ]]; then
    echo "$SPACESHIP_GCLOUD_STATUS_CONNECTED_COLOR"
    return
  fi

  local tmp_dir="${promptDir}/tmp"
  mkdir -p "$tmp_dir"
  local cache_file="${tmp_dir}/gcloud_status_color"

  if [[ "$SPACESHIP_GCLOUD_STATUS_CACHE" == true ]]; then
    if [[ -f "$cache_file" && $(($(date +%s) - $(stat -f %m "$cache_file"))) -lt $SPACESHIP_GCLOUD_STATUS_CACHE_TIMEOUT ]]; then
      cat "$cache_file"
      return
    fi
  fi

  local globally_active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null)

  if [[ -z "$globally_active_account" ]] || [[ "$globally_active_account" != "$active_account" ]]; then
    echo $SPACESHIP_GCLOUD_STATUS_DISCONNECTED_COLOR | tee "$cache_file" 2>/dev/null
  else
    echo $SPACESHIP_GCLOUD_STATUS_CONNECTED_COLOR | tee "$cache_file" 2>/dev/null
  fi
}

spaceship_gcloud_status() {
  [[ $SPACESHIP_GCLOUD_SHOW == false ]] && return

  spaceship::exists gcloud || return

  local gcloud_dir=${CLOUDSDK_CONFIG:-"${HOME}/.config/gcloud"}

  if (( ${+CLOUDSDK_ACTIVE_CONFIG_NAME} )); then
    local gcloud_active_config=${CLOUDSDK_ACTIVE_CONFIG_NAME}
  else
    local gcloud_active_config=$(head -n1 $gcloud_dir/active_config)
  fi

  [[ -n $gcloud_active_config ]] || return

  local gcloud_active_config_file=$gcloud_dir/configurations/config_$gcloud_active_config
  [[ -f $gcloud_active_config_file ]] || return

  local gcloud_active_account=$(sed -n 's/account = \(.*\)/\1/p' "$gcloud_active_config_file")
  [[ -n "$gcloud_active_account" ]] || return

  local gcloud_active_project=$(sed -n 's/project = \(.*\)/\1/p' "$gcloud_active_config_file")
  [[ -n "$gcloud_active_project" ]] || return

  local gcloud_status_color=$(get_gcloud_status_color "$gcloud_active_account")
  local gcloud_status="$gcloud_active_config/$gcloud_active_project"

  spaceship::section \
    --color "$gcloud_status_color" \
    --prefix "$SPACESHIP_GCLOUD_STATUS_PREFIX" \
    --suffix "$SPACESHIP_GCLOUD_STATUS_SUFFIX" \
    --symbol "$SPACESHIP_GCLOUD_STATUS_SYMBOL" \
    "$gcloud_status"
}