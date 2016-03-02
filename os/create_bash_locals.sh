#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

create_bash_locals() {

    if [ ! -f "$HOME/.bash.local" ]; then
        echo "" > "$HOME/.bash.local"
    fi

    if [ ! -f "$HOME/.bash.local.proxy" ]; then
        echo "" > "$HOME/.bash.local.proxy"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

create_bash_locals

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset create_bash_locals
