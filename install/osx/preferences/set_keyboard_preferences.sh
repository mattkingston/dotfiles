#!/usr/bin/env bash

set_keyboard_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Keyboard'

  execute 'defaults write NSGlobalDomain AppleKeyboardUIMode -int 3' \
    'Enable full keyboard access for all controls'

  execute 'defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false' \
    'Disable press-and-hold in favor of key repeat'

  execute 'defaults write NSGlobalDomain "InitialKeyRepeat_Level_Saved" -int 15' \
    'Set delay until repeat'

  execute 'defaults write NSGlobalDomain KeyRepeat -int 2' \
    'Set the key repeat rate to fast'

  execute 'defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false' \
    'Disable smart quotes'

  execute 'defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false' \
    'Disable smart dashes'
}

set_keyboard_preferences

unset set_keyboard_preferences
