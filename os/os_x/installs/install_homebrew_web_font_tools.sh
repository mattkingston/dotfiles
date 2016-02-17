#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_homebrew_web_font_tools() {

    # Webfont tools
    # https://github.com/bramstein/homebrew-webfonttools

    if cmd_exists 'brew' \
        && add_to_source_list 'bramstein/webfonttools'; then

        install_package 'TTF/OTF → WOFF' 'sfnt2woff'
        install_package 'TTF/OTF → WOFF (Zopfli)' 'sfnt2woff-zopfli'
        install_package 'WOFF2' 'woff2'

    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_homebrew_web_font_tools

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_homebrew_web_font_tools