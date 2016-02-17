#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_maps_preferences() {

    print_info 'Maps'

    execute 'defaults write com.apple.Maps LastClosedWindowViewOptions "{
                localizeLabels = 1;   // show labels in English
                mapType = 11;         // show hybrid map
                trafficEnabled = 0;   // do not show traffic
             }"' \
        'Set view options'

    killall 'Maps' &> /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_maps_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_maps_preferences