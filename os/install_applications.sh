#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_applications() {
    declare -r OS="$(get_os)"
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    if [ "$OS" == 'osx' ]; then
        source ./os_x/installs/main.sh
        source ./os_x/change_default_bash_version.sh
    elif [ "$OS" == 'ubuntu' ]; then
        source ./ubuntu/installs/main.sh
    fi
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    cd "$workingDirectory"
    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_applications

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_applications
