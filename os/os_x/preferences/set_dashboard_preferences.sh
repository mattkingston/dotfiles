#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_dashboard_preferences() {

    print_info 'Dashboard'

    execute 'defaults write com.apple.dashboard mcx-disabled -bool true' \
        'Disable Dashboard'

    # 'killall Dashboard' doesn't actually do anything. To apply
    # the changes for Dashboard, 'killall Dock' is enough as Dock
    # is Dashboard's parent process.

    killall 'Dock' &> /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_dashboard_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_dashboard_preferences
