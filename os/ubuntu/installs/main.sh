#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

main() {

    update_and_upgrade
    print_break

    ./install_packages.sh
    print_break

    update_and_upgrade
    print_break

    # Remove packages that were automatically installed to satisfy
    # dependencies for other other packages and are no longer needed

    execute 'sudo apt-get autoremove -qqy' 'Autoremove'

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

main

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset main
