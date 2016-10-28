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
      curl -L https://rvm.io/mpapis.asc 1>> ~/.dotfiles.log | gpg --import - 1>> ~/.dotfiles.log
    fi

    curl -L https://get.rvm.io 1>> ~/.dotfiles.log | bash -s stable --ignore-dotfiles --path "$RVM_DIR" 1>> ~/.dotfiles.log

    print_result $? 'RVM'
  fi

  . ~/.dotfiles/bash/autocomplete.sh

  if [[ -n "${http_proxy}" ]]; then
    ask_for_confirmation 'Do you want to use existing Proxy settings for Ruby (global)?'

    if answer_is_yes; then
      save_proxy_settings_to_gem
    fi
  fi

  # Install ruby versions
  for i in "${ruby_versions[@]}"; do
    rvm --install ${i} 1>> ~/.dotfiles.log
    print_result $? "RVM install: ${i}"
  done

  for i in "${ruby_versions[@]}"; do
    ask_for_confirmation "Do you want to use ruby ${i} as the default?"

    if answer_is_yes; then
      rvm_default "${i}"
      break
    fi
  done

  rvm cleanup all 1>> ~/.dotfiles.log
  print_result $? "RVM (cleanup)"

  if [[ "$OS" == 'osx' ]]; then
    rvm osx-ssl-certs update all 1>> ~/.dotfiles.log
    print_result $? "Update OS X SSL certs"
  fi

  cd "${pwd}"
}

install_rvm

unset install_rvm
