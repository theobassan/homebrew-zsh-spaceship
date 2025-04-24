#!/bin/zsh

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

ZSH_SPACESHIP_OS_ICON_SHOW_OS_ICON="${ZSH_SPACESHIP_OS_ICON_SHOW_OS_ICON=true}"
ZSH_SPACESHIP_OS_ICON_COLOR="${ZSH_SPACESHIP_OS_ICON_COLOR=39}"

ZSH_SPACESHIP_OS_ICON_SUNOS_SYMBOL="${ZSH_SPACESHIP_OS_ICON_SUNOS_SYMBOL=\uf185}"
ZSH_SPACESHIP_OS_ICON_APPLE_SYMBOL="${ZSH_SPACESHIP_OS_ICON_APPLE_SYMBOL=\uf179}"
ZSH_SPACESHIP_OS_ICON_WINDOWS_SYMBOL="${ZSH_SPACESHIP_OS_ICON_WINDOWS_SYMBOL=\uf17a}"
ZSH_SPACESHIP_OS_ICON_FREEBSD_SYMBOL="${ZSH_SPACESHIP_OS_ICON_FREEBSD_SYMBOL=\uf30c}"
ZSH_SPACESHIP_OS_ICON_LINUX_SYMBOL="${ZSH_SPACESHIP_OS_ICON_LINUX_SYMBOL=\uebc6}"
ZSH_SPACESHIP_OS_ICON_UNKNOWN_SYMBOL="${ZSH_SPACESHIP_OS_ICON_UNKNOWN_SYMBOL=\uebc3}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_os_icon() {
  [[ $ZSH_SPACESHIP_OS_ICON_SHOW_OS_ICON == false ]] && return

  local os_icon
  local os_name
  local os_name2

  os_name="$(uname)"

  if [[ $os_name == Linux ]]; then
    os_name2="$(uname -o 2>/dev/null)"
    os_name="$(uname -m)"
  fi

  if [[ $os_name == Linux && $os_name2 == Android ]]; then
    os_icon=""
  else
    case $os_name in
      SunOS)                      os_icon=$ZSH_SPACESHIP_OS_ICON_SUNOS_SYMBOL;;
      Darwin)                     os_icon=$ZSH_SPACESHIP_OS_ICON_APPLE_SYMBOL;;
      CYGWIN*|MINGW*|MSYS*)       os_icon=$ZSH_SPACESHIP_OS_ICON_WINDOWS_SYMBOL;;
      FreeBSD|OpenBSD|DragonFly)  os_icon=$ZSH_SPACESHIP_OS_ICON_FREEBSD_SYMBOL;;
      Linux)                      os_icon=$ZSH_SPACESHIP_OS_ICON_LINUX_SYMBOL;;
      *)                          os_icon=$ZSH_SPACESHIP_OS_ICON_UNKNOWN_SYMBOL;;
    esac
  fi

  spaceship::section \
    --color "$ZSH_SPACESHIP_OS_ICON_COLOR" \
    "$os_icon "
}
