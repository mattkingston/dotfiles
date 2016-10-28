#!/usr/bin/env bash

install_applications() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  if [[ "$OS" == 'osx' ]]; then
    ./osx/install_applications.sh
  elif [[ "$OS" == 'ubuntu' ]]; then
    ./ubuntu/install_applications.sh
  fi

  cd "${pwd}"
}

install_applications

unset install_applications
