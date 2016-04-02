#!/usr/bin/env bash

set_preferences() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  declare -a terminate_after=(
    'SystemUIServer'
    'cfprefsd'
  )

#  if brew_list 'chrome'; then
#    ./set_chrome_preferences.sh
#  fi

  ./set_dashboard_preferences.sh
  ./set_dock_preferences.sh
  ./set_finder_preferences.sh
  ./set_keyboard_preferences.sh
  ./set_language_and_region_preferences.sh
  ./set_maps_preferences.sh
  ./set_safari_preferences.sh
  ./set_terminal_preferences.sh
  ./set_textedit_preferences.sh
  ./set_trackpad_preferences.sh

#  if brew_list 'transmission'; then
#    ./set_transmission_preferences.sh
#  fi

  ./set_ui_and_ux_preferences.sh

  for i in "${terminate_after[*]}"; do
    killall "$i" &> /dev/null
  done

  cd "${pwd}"
}

set_preferences

unset set_preferences
