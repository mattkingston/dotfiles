#!/usr/bin/env bash

install_nvm() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local -a node_versions=(
    '0.12.12'
    'node'
  )

  local use_default_version='node'

  if ! cmd_exists 'git'; then
    print_error 'Git is required to install NVM'
    exit 1
  fi

  if [ ! -d "${NVM_DIR}" ]; then
    git clone https://github.com/creationix/nvm.git "$NVM_DIR" | dotfiles_log

    if [[ "$PIPESTATUS[0]" -eq 0 ]]; then
      cd "$NVM_DIR"

      git checkout `git describe --abbrev=0 --tags` | dotfiles_log

      if [[ "$PIPESTATUS[0]" -eq 0 ]]; then
        print_success 'NVM'
      else
        print_error 'NVM'
      fi
    else
      print_error 'NVM'
    fi
  fi

  . ~/.dotfiles/bash/autocomplete.sh

  nvm_update \
    && source "${NVM_DIR}/nvm.sh"

  # Install node versions
  for i in "${node_versions[@]}"; do
    if [[ "$(nvm ls "$i" | grep -q "N/A")" -ne 1 ]]; then
      execute "nvm install $i | dotfiles_log" "NVM install: $i"
    fi
  done

  nvm_default "${use_default_version}"

  cd "${pwd}"
}

install_nvm

unset install_nvm
