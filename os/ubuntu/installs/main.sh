#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

main() {

    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    update_and_upgrade
    print_break

    source ./install_packages.sh
    print_break

    update_and_upgrade
    print_break

    # Remove packages that were automatically installed to satisfy
    # dependencies for other other packages and are no longer needed

    execute 'sudo apt-get autoremove -qqy' 'Autoremove'

    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

main

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset main
