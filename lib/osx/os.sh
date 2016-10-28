#!/usr/bin/env bash

# OSX OS utils

brew_install() {
  local command="${3}"
  local formula="${2}"
  local formula_name="${1}"

  if [[ "$command" == "" ]]; then
    brew list $formula 2> /dev/null

    if [[ $? -eq 0 ]]; then
      print_success "${formula_name}"
    else
      brew install $formula 1>> ~/.dotfiles.log
      print_result $? "${formula_name}"
    fi
  else
    brew "$command" list $formula 2> /dev/null

    if [[ $? -eq 0 ]]; then
      print_success "${formula_name}"
    else
      brew "$command" install $formula 1>> ~/.dotfiles.log
      print_result $? "${formula_name}"
    fi
  fi
}

brew_link() {
  local command="${3}"
  local formula="${2}"
  local formula_name="${1}"

  brew list $formula 2> /dev/null

  if [[ $? -eq 0 ]]; then
    brew link $formula 1>> ~/.dotfiles.log
    print_result $? "$formula_name"
  fi
}

brew_tap() {
  local repository="$1"

  if brew tap | grep -q "$repository"; then
    print_success "tap: ${repository}"
  else
    brew tap "${repository}" 1>> ~/.dotfiles.log
    print_result $? "tap: ${repository}"
  fi
}

brew_list() {
  local command="${2}"
  local formula="${1}"

  brew "$command" list $formula 2> /dev/null \
    && return 0 \
    || return 1;
}

update_osx() {
  # System software update tool
  # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/softwareupdate.8.html
  sudo softwareupdate --install --all 1>> ~/.dotfiles.log \
    && print_success 'Update system software' \
    || print_error 'Update system software'
}

update_brew() {
  brew update 1>> ~/.dotfiles.log
  print_result $? 'brew (update)'

  brew upgrade --all 1>> ~/.dotfiles.log
  print_result $? 'brew (upgrade)'

  brew cleanup 1>> ~/.dotfiles.log
  print_result $? 'brew (cleanup)'
}
