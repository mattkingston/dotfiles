#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

update_content() {

    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    if is_git_repository; then

        # Update content and remove untracked files
        git fetch --all &> /dev/null \
            && git reset --hard origin/master &> /dev/null \
            && git clean -fd  &> /dev/null

        print_result $? 'Update content'

    fi
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

update_content

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset update_content