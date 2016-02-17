#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

main() {

    ./set_privacy_preferences.sh
    ./set_terminal_preferences.sh
    ./set_ui_and_ux_preferences.sh

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

main

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset main