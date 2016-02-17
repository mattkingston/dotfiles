#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_chrome_canary_preferences() {

    print_info 'Chrome Canary'

    execute 'defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false' \
        'Disable backswipe'

    execute 'defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true' \
        'Expand print dialog by default'

    execute 'defaults write com.google.Chrome.canary DisablePrintPreview -bool true' \
        'Use system-native print preview dialog'

    killall 'Google Chrome Canary' &> /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_chrome_canary_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_chrome_canary_preferences
