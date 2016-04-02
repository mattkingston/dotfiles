#!/usr/bin/env bash

set_chrome_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Chrome'

  execute 'defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false' \
    'Disable backswipe'

  execute 'defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true' \
    'Expand print dialog by default'

  execute 'defaults write com.google.Chrome DisablePrintPreview -bool true' \
    'Use system-native print preview dialog'

  killall 'Google Chrome' &> /dev/null
}

set_chrome_preferences

unset set_chrome_preferences
