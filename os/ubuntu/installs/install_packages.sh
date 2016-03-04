#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_packages() {

    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    update

    install_package 'Debian Configuration Utils' 'debconf-utils' # Tools for managing binaries (used for dpkg-divert below)
    install_package 'GSettings' 'libglib2.0-bin' # Simple configuration storage system
    install_package 'Build Essential' 'build-essential' # Tools for compiling/building software from source
    install_package 'GnuPG archive keys' 'debian-archive-keyring' # GnuPG archive keys of the Debian archive
    install_package 'Common Software Properties' 'software-properties-common'
    install_package 'Python Software Properties' 'python-software-properties'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Allow un-authenticated Apt repositories to install software
    # Required for latest git version (default apt version is 1.7 - too low)
    # Required for java core team ppa

    echo 'APT::Get::AllowUnauthenticated 1;' | sudo tee "/etc/apt/apt.conf.d/02allow-unsigned" > /dev/null 2>&1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Pre-Accept keys

    accept_key "keyserver.ubuntu.com" "C2518248EEA14886"
    accept_key "keyserver.ubuntu.com" "EF4186FE247510BE" # Mozilla nightly key
    accept_key "keyserver.ubuntu.com" "A1715D88E1DF1F24" # Git
    accept_key "keyserver.ubuntu.com" "63F7D4AFF6D61D45" # Opera

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Add PPAs

    if ! package_is_installed 'atom'; then
        add_ppa 'webupd8team/atom' "Atom (add PPA)"
    fi

    if ! package_is_installed 'firefox-trunk'; then
        add_ppa 'ubuntu-mozilla-daily/ppa' "Firefox Nightly (add PPA)"
    fi

    if ! package_is_installed 'git'; then
        add_ppa 'git-core/ppa' "Git (add PPA)"
    fi

    if ! package_is_installed 'opera'; then
        add_key 'http://deb.opera.com/archive.key'
        add_to_source_list 'http://deb.opera.com/opera/ stable non-free' 'opera.list' 'Opera (add sources)'
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    update

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Atom' 'atom'
    install_package 'Firefox Nightly' 'firefox-trunk'
    install_package 'Opera' 'opera'
    install_package 'Opera Next' 'opera-next'
    install_package 'Git' 'git'
    install_package 'Chromium' 'chromium-browser'
    install_package 'cURL' 'curl'
    install_package 'Dropbox' 'nautilus-dropbox'
    install_package 'Flash' 'flashplugin-installer'
    install_package 'GIMP' 'gimp'
    install_package 'GNOME Vim' 'vim-gnome'
    install_package 'ImageMagick' 'imagemagick'
    install_package 'tmux' 'tmux'
    install_package 'Transmission' 'transmission'
    install_package 'VirtualBox' 'virtualbox'
    install_package 'VLC' 'vlc'
    install_package 'xclip' 'xclip'
    install_package 'Zip' 'zip'
    install_package 'PCRE' 'pcregrep'
    install_package 'Apache Ant' 'ant'
    install_package 'SSHPass' 'sshpass'
    install_package 'JQ' 'jq'
    install_package 'Ack Grep' 'ack-grep'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    git config --global http.sslverify false

    # Use `ack` instead of `grep-ack` by default
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_packages

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_packages
