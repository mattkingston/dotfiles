#!/usr/bin/env bash

set_language_and_region_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Language & Region'

  execute 'defaults write NSGlobalDomain AppleLanguages -array "en"' \
    'Set language'

  execute 'defaults write NSGlobalDomain AppleLocale -string "en_AU@currency=AUD"' \
    'Set locale'

  execute 'defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"' \
    'Set measurement units'

  execute 'sudo systemsetup -settimezone "Australia/Melbourne"' \
    'Set timezone'

  execute 'defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false' \
    'Disable auto-correct'
}

set_language_and_region_preferences

unset set_language_and_region_preferences
