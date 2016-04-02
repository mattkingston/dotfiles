#!/usr/bin/env bash

set_privacy_preferences() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Privacy'

  if gsettings list-recursively | grep -q "com.canonical.Unity.Lenses"; then
    execute 'gsettings set com.canonical.Unity.Lenses remote-content-search "none"' \
      'Turn off "Remote Search" so that search terms in Dash do not get sent over the internet'
  fi

  if gsettings list-recursively | grep -q "com.canonical.Unity.ApplicationsLens"; then
    execute 'gsettings set com.canonical.Unity.ApplicationsLens display-available-apps false' \
      'Disable Dash "More suggestions" section'
  fi

  cd "${pwd}"
}

set_privacy_preferences

unset set_privacy_preferences
