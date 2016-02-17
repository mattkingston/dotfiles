#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_chrome_preferences() {

    print_info 'Chrome'

    execute 'defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false' \
        'Disable backswipe'

    execute 'defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true' \
        'Expand print dialog by default'

    execute 'defaults write com.google.Chrome DisablePrintPreview -bool true' \
        'Use system-native print preview dialog'

    killall 'Google Chrome' &> /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_chrome_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_chrome_preferences
