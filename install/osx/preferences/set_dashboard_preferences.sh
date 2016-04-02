#!/usr/bin/env bash

set_dashboard_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Dashboard'

  execute 'defaults write com.apple.dashboard mcx-disabled -bool true' \
    'Disable Dashboard'

  # 'killall Dashboard' doesn't actually do anything. To apply
  # the changes for Dashboard, 'killall Dock' is enough as Dock
  # is Dashboard's parent process.

  killall 'Dock' &> /dev/null
}

set_dashboard_preferences

unset set_dashboard_preferences
