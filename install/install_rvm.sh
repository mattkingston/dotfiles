#!/usr/bin/env bash

install_rvm() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local -a ruby_versions=(
    '1.9.3'
    '2.3.0'
  )

  local use_default_version='2.3.0'

  if ! cmd_exists 'curl'; then
    print_error 'Curl is required to install RVM'
    exit 1
  fi

  if [ ! -d "${RVM_DIR}" ]; then
    # Import RVM keys first
    if cmd_exists 'gpg'; then
      curl -sSL https://rvm.io/mpapis.asc | gpg --import - &> /dev/null
    fi

    curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles --path "$RVM_DIR" &> /dev/null

    print_result $? 'RVM'
  fi

  . ~/.dotfiles/bash/autocomplete.sh

  # Install ruby versions
  for i in "${ruby_versions[@]}"; do
    execute "rvm --quiet-curl --install ${i}" "RVM install: ${i}"
  done

  rvm_default "${use_default_version}"

  execute "rvm cleanup all" "RVM (cleanup)"

  if [[ "$OS" == 'osx' ]]; then
    execute "rvm osx-ssl-certs update all" "Update OS X SSL certs"
  fi

  cd "${pwd}"
}

install_rvm

unset install_rvm