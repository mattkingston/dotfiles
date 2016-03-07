#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_homebrew_casks() {

    # Homebrew Casks
    # https://github.com/caskroom/homebrew-cask

    if cmd_exists 'brew' \
        && add_to_source_list 'caskroom/cask'; then

        install_package 'Homebrew Cask' 'caskroom/cask/brew-cask'
        printf '\n'

        # Services

        ask_for_confirmation "Do you want to install service apps?"

        if answer_is_yes; then
            install_package 'BlueHarvest' 'blueharvest' 'cask'
            install_package 'Caffeine' 'caffeine' 'cask'
            install_package 'GFX Card Status' 'gfxcardstatus' 'cask'
            install_package 'Razer Synapse' 'razer-synapse' 'cask'
            install_package 'Rescue Time' 'rescuetime' 'cask'
        fi

        # Utils

        ask_for_confirmation "Do you want to install util apps?"

        if answer_is_yes; then
            install_package 'iExplorer' 'iexplorer' 'cask'
            install_package 'DFont Splitter' 'dfontsplitter' 'cask'
            install_package 'Daisy Disk' 'daisydisk' 'cask'
            install_package 'Clean my Mac' 'cleanmymac' 'cask'
            install_package 'GIMP' 'lisanet-gimp' 'cask'
            install_package 'ImageOptim' 'imageoptim' 'cask'
            install_package 'LICEcap' 'licecap' 'cask'
            install_package 'Unarchiver' 'the-unarchiver' 'cask'
            install_package 'Keyboard Cleaner' 'keyboard-cleaner' 'cask'
        fi

        # Security

        ask_for_confirmation "Do you want to install security apps?"

        if answer_is_yes; then
            install_package 'Avast Security' 'avast' 'cask'
        fi

        # Browsers

        ask_for_confirmation "Do you want to install browser apps?"

        if answer_is_yes; then
            install_package 'Chrome' 'google-chrome' 'cask'
            install_package 'Chromium' 'chromium' 'cask'
            install_package 'Firefox' 'firefox' 'cask'
            install_package 'Flash' 'flash' 'cask'
            install_package 'Opera' 'opera' 'cask'
        fi

        # Productivity

        ask_for_confirmation "Do you want to install productivity apps?"

        if answer_is_yes; then
            install_package 'Alfred' 'alfred' 'cask'
            install_package 'Dropbox' 'dropbox' 'cask'
            install_package '1Password' '1password' 'cask'
            install_package 'Divvy' 'divvy' 'cask'
            install_package 'Day One (cli)' 'dayone-cli' 'cask'
            install_package 'Evernote' 'evernote' 'cask'
            install_package 'Things' 'things' 'cask'
            install_package 'Adobe Reader' 'adobe-reader' 'cask'
        fi

        # Business

        ask_for_confirmation "Do you want to install business related apps?"

        if answer_is_yes; then
            install_package 'Microsoft Office' 'microsoft-office' 'cask'
            install_package 'YNAB' 'ynab' 'cask'
        fi

        ask_for_confirmation "Do you want to install Adobe Cloud?"

        if answer_is_yes; then
            install_package 'Adobe Cloud' 'adobe-creative-cloud' 'cask'
        fi

        # Programming IDE

        ask_for_confirmation "Do you want to install programming IDE's?"

        if answer_is_yes; then
            install_package 'CLion' 'clion' 'cask'
            install_package 'Unity 3D' 'unity' 'cask'
        fi

        # Development IDE/Editors

        ask_for_confirmation "Do you want to install development IDE's?"

        if answer_is_yes; then
            install_package 'Web Storm' 'webstorm' 'cask'
            install_package 'PHP Storm' 'phpstorm' 'cask'
            install_package 'Intellij IDEA' 'intellij-idea' 'cask'
            install_package 'Sublime Text' 'sublime-text' 'cask'
        fi

        # Development App

        ask_for_confirmation "Do you want to install development apps?"

        if answer_is_yes; then
            install_package 'Querious' 'querious' 'cask'
            install_package 'Sequel Pro' 'sequel-pro' 'cask'
            install_package 'Transmit' 'transmit' 'cask'
            install_package 'Kaleidoscope' 'kaleidoscope' 'cask'
        fi

        # Virtualization

        ask_for_confirmation "Do you want to install virtualization apps?"

        if answer_is_yes; then
            install_package 'VirtualBox' 'virtualbox' 'cask'
            install_package 'Citrix Receiver' 'citrix-receiver' 'cask' # Can we move this to FB dotfiles?
            install_package 'VMWare Fusion' 'vmware-fusion' 'cask'
            install_package 'Parallels Desktop' 'parallels-desktop' 'cask'
        fi

        # Torrent

        ask_for_confirmation "Do you want to install pirate apps?"

        if answer_is_yes "N"; then
            install_package 'Transmission' 'transmission' 'cask'
            install_package 'uTorrent' 'utorrent' 'cask'
        fi

        # Entertainment

        ask_for_confirmation "Do you want to install entertainment apps?"

        if answer_is_yes; then
            install_package 'VLC' 'vlc' 'cask'
            install_package 'Spotify' 'spotify' 'cask'
            install_package 'Steam' 'steam' 'cask'
            install_package 'Boxer' 'boxer' 'cask'
            install_package 'DOSBox' 'dosbox' 'cask'
            install_package 'Battle.net' 'battle-net' 'cask'
        fi

        # Dont have casks for;
        # ALZip
        # Converto
        # img2icns
        # Markdown Pro
        # Reeder
        # SQL Developer
        # GTA III, San Andreas, Vice City
        # LBA1 & LBA2
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_homebrew_casks

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_homebrew_casks
