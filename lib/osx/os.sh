#!/usr/bin/env bash

# OSX OS utils

brew_install() {
  local command="${3}"
  local formula="${2}"
  local formula_name="${1}"

  if [[ "$command" == "" ]]; then
    brew list $formula > /dev/null \
      && print_success "${formula_name}" \
      || execute "brew $command install $formula" "${formula_name}"
  else
    brew $command list $formula > /dev/null \
      && print_success "${formula_name}" \
      || execute "brew $command install $formula" "${formula_name}"
  fi
}

brew_link() {
  local command="${3}"
  local formula="${2}"
  local formula_name="${1}"

  brew list $formula > /dev/null \
    && execute "brew link $formula" "$formula_name"
}

brew_tap() {
  local repository="$1"

  brew tap | grep -q "$repository" > /dev/null \
    && print_success "tap: ${repository}" \
    || execute "brew tap ${repository}" "tap: ${repository}"
}

brew_list() {
  local command="${2}"
  local formula="${1}"

  brew $command list $formula > /dev/null \
    && return 0 \
    || return 1;
}

update_osx() {
  # System software update tool
  # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/softwareupdate.8.html
  sudo softwareupdate --install --all > /dev/null \
    && print_success 'Update system software' \
    || print_error 'Update system software'
}

update_brew() {
  execute 'brew update' 'brew (update)'
  execute 'brew upgrade --all' 'brew (upgrade)'
  execute 'brew cleanup' 'brew (cleanup)'
}
