#!/usr/bin/env bash

install_npm_packages() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local -a packages=(
    'babel'
    'jshint'
  )

  if ! cmd_exists 'npm'; then
    print_error 'NPM is required to install NPM packages. NPM is not installed or not found'
    return 1
  fi

  npm_config_registry
#  npm_update

  for i in "${packages[@]}"; do
    echo "NPM: Installing $i. Please wait" >> ~/.dotfiles.log
    npm install --global "${i}" 1>> ~/.dotfiles.log
    print_result $? "${i}"
  done

  cd "${pwd}"
}

install_npm_packages

unset install_npm_packages
