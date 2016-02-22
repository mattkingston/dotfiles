#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

initialize_git_repository() {

    declare -r GIT_ORIGIN="$1"
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    [ -z "$GIT_ORIGIN" ] \
        && print_error 'Please provide a URL for the Git origin'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_git_repository; then

        # Run the following Git commands in the root of
        # the dotfiles directory, not in the `os/` directory
        # cd ..

        git init &> /dev/null \
            && git remote add origin "$GIT_ORIGIN" &> /dev/null

        print_result $? 'Initialize the Git repository'

    fi
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

initialize_git_repository "$1"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset initialize_git_repository