#!/usr/bin/env bash

set_preferences() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  # Simple configuration storage system
  apt_install 'GSettings' 'libglib2.0-bin' # Allows using gsettings for all preferences

  ./set_privacy_preferences.sh
  ./set_terminal_preferences.sh
  ./set_ui_and_ux_preferences.sh

  cd "${pwd}"
}

set_preferences

unset set_preferences