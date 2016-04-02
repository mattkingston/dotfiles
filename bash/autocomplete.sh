#!/usr/bin/env bash

if [[ "${OS}" == 'osx' ]]; then
  . "${DOTFILES_DIR}/bash/osx/autocomplete.sh"
elif [[ "$OS" == 'ubuntu' ]]; then
  . "${DOTFILES_DIR}/bash/ubuntu/autocomplete.sh"
fi

# NVM

[[ -n "${NVM_DIR}" && -f "${NVM_DIR}/bash_completion" ]] \
  && . "${NVM_DIR}/bash_completion"

if [[ -n "$NVM_DIR" && -f "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
fi

# RVM

if [[ -f "$RVM_DIR/scripts/completion" ]]; then
  . "$RVM_DIR/scripts/completion"
fi

if [[ -s "$RVM_DIR/scripts/rvm" ]]; then
  . "$RVM_DIR/scripts/rvm"
fi
