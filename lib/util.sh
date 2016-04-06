#!/usr/bin/env bash

ask_for_sudo() {
  # Ask for the administrator password upfront
  sudo -v &> /dev/null

  # Update existing `sudo` time stamp until this script has finished
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &
}

can_sudo() {
  [[ "$(whoami)" != "root" && ! is_interactive_session ]] \
    && return 0 \
    || return 1;
}

is_interactive_session() {
  [[ -t "0" || ( -t "0" || -p /dev/stdin ) ]] \
    && return 0 \
    || return 1;
}

cmd_exists() {
  command -v "${1}" > /dev/null
  return "$?"
}

fn_exists() {
  type -t "${1}" > /dev/null \
    && return 0 \
    || return 1
}

is_callable() {
  if fn_exists "$1" || cmd_exists "$1"; then
    return 0
  fi

  return 1
}

execute() {
  eval "${1}"

  if [[ "$PIPESTATUS[0]" -eq 0 ]]; then
    print_success "${2}"
    return 0
  fi

  print_error "${2:-$1}"
  return 1
}

restart() {
  sudo shutdown -r now
}
