#!/usr/bin/env bash

set_preferences() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  if [[ "$OS" == 'osx' ]]; then
    ./osx/preferences/set_preferences.sh
  elif [[ "$OS" == 'ubuntu' ]]; then
    ./ubuntu/preferences/set_preferences.sh
  fi

  cd "${pwd}"
}

set_preferences

unset set_preferences
