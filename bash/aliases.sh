#!/usr/bin/env bash

if [[ "${OS}" == 'osx' ]]; then
  . "${DOTFILES_DIR}/bash/osx/aliases.sh"
elif [[ "$OS" == 'ubuntu' ]]; then
  . "${DOTFILES_DIR}/bash/ubuntu/aliases.sh"
fi
