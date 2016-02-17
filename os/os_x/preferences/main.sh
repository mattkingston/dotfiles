#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

main() {

    declare -a PROCESSES_TO_TERMINATE=(
        'SystemUIServer'
        'cfprefsd'
    )
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE)"

    source ./set_chrome_preferences.sh
    source ./set_chrome_canary_preferences.sh
    source ./set_dashboard_preferences.sh
    source ./set_dock_preferences.sh
    source ./set_finder_preferences.sh
    source ./set_keyboard_preferences.sh
    source ./set_language_and_region_preferences.sh
    source ./set_maps_preferences.sh
    source ./set_safari_preferences.sh
    source ./set_terminal_preferences.sh
    source ./set_textedit_preferences.sh
    source ./set_trackpad_preferences.sh
    source ./set_transmission_preferences.sh
    source ./set_ui_and_ux_preferences.sh

    for i in ${PROCESSES_TO_TERMINATE[*]}; do
        killall "$i" &> /dev/null
    done
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

main

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset main
