#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_preferences() {
    declare -r OS="$(get_os)"
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE)"

    if [ "$OS" == 'osx' ]; then
        source ./os_x/preferences/main.sh
    elif [ "$OS" == 'ubuntu' ]; then
        source ./ubuntu/preferences/main.sh
    fi
    
    cd "$workingDirectory"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_preferences
