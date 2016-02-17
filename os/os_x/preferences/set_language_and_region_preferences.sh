#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_language_and_region_preferences() {

    print_info 'Language & Region'

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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_language_and_region_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_language_and_region_preferences
