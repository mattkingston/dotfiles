#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_homebrew_versions_formulae() {

    # Homebrew Versions Formulae
    # https://github.com/Homebrew/homebrew-versions

    if cmd_exists 'brew' \
        && add_to_source_list 'homebrew/versions'; then

        install_package 'Bash Completion 2' 'bash-completion2'

    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_homebrew_versions_formulae

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_homebrew_versions_formulae
