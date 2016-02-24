#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_homebrew_formulae() {

    # Homebrew Formulae
    # https://github.com/Homebrew/homebrew

    if cmd_exists 'brew'; then
        install_package 'Bash 4.x' 'bash'
        install_package 'FFmpeg' 'ffmpeg'
        install_package 'Git' 'git'
        install_package 'ImageMagick' 'imagemagick --with-webp'
        install_package 'Zopfli' 'zopfli'
        install_package 'tmux' 'tmux'
        install_package 'PCRE' 'pcre'
        install_package 'Vim' 'vim --override-system-vi'
        install_package 'Ack' 'ack'
        install_package 'JQ' 'jq'
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_homebrew_formulae

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_homebrew_formulae
