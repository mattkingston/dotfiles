#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_dock_preferences() {

    print_info 'Dock'

    execute 'defaults write com.apple.dock autohide -bool true' \
        'Automatically hide/show the Dock'

    execute 'defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true' \
        'Enable spring loading for all Dock items'

    execute 'defaults write com.apple.dock expose-animation-duration -float 0.2' \
        'Speed up Mission Control animations'

    execute 'defaults write com.apple.dock expose-group-by-app -bool false' \
        'Do not group windows by application in Mission Control'

    execute 'defaults write com.apple.dock mineffect -string "scale"' \
        'Change minimize/maximize window effect'

    execute 'defaults write com.apple.dock minimize-to-application -bool false' \
        'Do not minimize windows into their application icons'

    execute 'defaults write com.apple.dock mru-spaces -bool false' \
        'Do not automatically rearrange spaces based on most recent use'

    execute 'defaults write com.apple.dock persistent-apps -array "" &&
             defaults write com.apple.dock persistent-others -array ""' \
        'Wipe all app icons'

    execute 'defaults write com.apple.dock show-process-indicators -bool true' \
        'Show indicator lights for open applications'

    execute 'defaults write com.apple.dock showhidden -bool true' \
        'Make icons of hidden applications translucent'

    execute 'defaults write com.apple.dock tilesize -int 60' \
        'Set icon size'

    killall 'Dock' &> /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_dock_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_dock_preferences
