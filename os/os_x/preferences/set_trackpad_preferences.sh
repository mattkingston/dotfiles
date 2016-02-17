#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_trackpad_preferences() {

    print_info 'Trackpad'

    execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false &&
             defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 0 &&
             defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0' \
        'Disable "Tap to click"'

    execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true &&
             defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true &&
             defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0 &&
             defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 0' \
        'Map "click or tap with two fingers" to the secondary click'

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_trackpad_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_trackpad_preferences
