#!/usr/bin/env bash

set_preferences() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  ./set_privacy_preferences.sh
  ./set_terminal_preferences.sh
  ./set_ui_and_ux_preferences.sh

  cd "${pwd}"
}

set_preferences

unset set_preferences