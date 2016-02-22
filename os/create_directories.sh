#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Variables

declare -a DIRECTORIES=(
    "archive"
    "downloads/torrents"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

create_directories() {
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    for i in ${DIRECTORIES[@]}; do
        mkd "$HOME/$i"
        print_success "$HOME/$i"
    done
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    cd "$workingDirectory"
    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

create_directories

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset create_directories
unset DIRECTORIES