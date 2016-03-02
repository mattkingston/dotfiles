#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_packages() {

    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    update

    # Tools for managing binaries (used for dpkg-divert below)
    install_package 'Debian Configuration Utils' 'debconf-utils'

    # Simple configuration storage system
    install_package 'GSettings' 'libglib2.0-bin'

    # Tools for compiling/building software from source
    install_package 'Build Essential' 'build-essential'

    # GnuPG archive keys of the Debian archive
    install_package 'GnuPG archive keys' 'debian-archive-keyring'

    # Software which is not included by default
    # in Ubuntu due to legal or copyright reasons
    #install_package 'Ubuntu Restricted Extras' 'ubuntu-restricted-extras'

    install_package 'Common Software Properties' 'software-properties-common'

    install_package 'Python Software Properties' 'python-software-properties'

    # Allow un-authenticated Apt repositories to install software
    # Required for latest git version (default apt version is 1.7 - too low)
    # Required for java core team ppa
    echo 'APT::Get::AllowUnauthenticated 1;' | sudo tee /etc/apt/apt.conf.d/02allow-unsigned"

    accept_key "keyserver.ubuntu.com" "C2518248EEA14886"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! package_is_installed 'atom'; then
        add_ppa 'webupd8team/atom' "Atom (add PPA)"

        update

        install_package 'Atom' 'atom'

    else
        print_success 'Atom'
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Chromium' 'chromium-browser'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'cURL' 'curl'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Dropbox' 'nautilus-dropbox'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Pre-accept key for Mozilla nightly

    accept_key "keyserver.ubuntu.com" "EF4186FE247510BE"

    if ! package_is_installed 'firefox-trunk'; then

        add_ppa 'ubuntu-mozilla-daily/ppa' "Firefox Nightly (add PPA)"

        update

        install_package 'Firefox Nightly' 'firefox-trunk'

    else
        print_success 'Firefox Nightly'
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Flash' 'flashplugin-installer'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'GIMP' 'gimp'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Pre-accept key for Git

    accept_key "keyserver.ubuntu.com" "A1715D88E1DF1F24"

    if ! package_is_installed 'git'; then

        add_ppa 'git-core/ppa' "Git (add PPA)"

        update

        install_package 'Git' 'git'

    else
        print_success 'Git'
    fi

    git config --global http.sslverify false

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'GNOME Vim' 'vim-gnome'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'ImageMagick' 'imagemagick'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    accept_key "keyserver.ubuntu.com" "63F7D4AFF6D61D45"

    if ! package_is_installed 'opera'; then

        add_key 'http://deb.opera.com/archive.key'

        add_to_source_list 'http://deb.opera.com/opera/ stable non-free' 'opera.list' 'Opera (add sources)'

        update

        install_package 'Opera' 'opera'
        install_package 'Opera Next' 'opera-next'

    else
        print_success 'Opera'
        print_success 'Opera Next'
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'tmux' 'tmux'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Transmission' 'transmission'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'VirtualBox' 'virtualbox'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'VLC' 'vlc'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'xclip' 'xclip'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # install_package 'Zopfli' 'zopfli'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Zip' 'zip'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'PCRE' 'pcregrep'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Apache Ant' 'ant'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'SSHPass' 'sshpass'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'Ack Grep' 'ack-grep'

    # Use `ack` instead of `grep-ack` by default
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_package 'JQ' 'jq'
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_packages

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_packages

