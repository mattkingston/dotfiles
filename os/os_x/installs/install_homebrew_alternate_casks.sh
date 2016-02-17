#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_homebrew_alternate_casks() {

    # Homebrew Alternate Casks
    # https://github.com/caskroom/homebrew-versions

    if cmd_exists 'brew' \
        && add_to_source_list 'caskroom/versions'; then

        install_package 'Chrome Canary' 'google-chrome-canary' 'cask'
        install_package 'Firefox Developer Edition' 'firefoxdeveloperedition' 'cask'
        install_package 'Firefox Nightly' 'firefox-nightly' 'cask'
        install_package 'Opera Beta' 'opera-beta' 'cask'
        install_package 'Opera Developer' 'opera-developer' 'cask'
        install_package 'WebKit' 'webkit-nightly' 'cask'
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_homebrew_alternate_casks

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_homebrew_alternate_casks
