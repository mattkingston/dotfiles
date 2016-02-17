#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

main() {

	local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE)"

    source ./install_xcode.sh
    source ./install_homebrew.sh
    source ./install_homebrew_formulae.sh
    source ./install_homebrew_versions_formulae.sh
    source ./install_homebrew_casks.sh
    source ./install_homebrew_alternate_casks.sh
    source ./install_homebrew_web_font_tools.sh

    update_and_upgrade

    source ./cleanup.sh
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

main

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset main
