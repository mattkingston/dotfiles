#!/usr/bin/env bash

ubuntu_install_applications() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"
  local cwd="$(pwd)"

  . ~/.dotfiles/bin/dotfiles

  local install_all="N"

  ask_install_or_update() {
    local application="$1"
    local application_readable="$2"
    local var="$3"

    if command -v "$application" > /dev/null; then
      ask_for_confirmation "Do you want to update $application_readable?";
    else
      ask_for_confirmation "Do you want to install $application_readable?";
    fi

    if answer_is_yes; then
      export "$var=Y"
      return 0
    else
      export "$var=N"
    fi
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  install_or_update() {
    local application="$1"
    local application_readable="$2"
    local var="$3"

    if [[ "${install_all}" == "Y" || "${!var}" == "Y" ]]; then
      if type -t "${var}" > /dev/null; then
        "${var}"
      else
        apt_install "$application_readable" "$application"

        touch ~/.dotfiles/."${application}"_installed
        echo "created: ~/.dotfiles/.${application}_installed" >> ~/.dotfiles.log
      fi
    fi
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  install_git() {
    apt_install 'Python Software Properties' 'python-software-properties' # Required in ubuntu 12.04 for add-apt-repository command
    apt_install 'Common Software Properties' 'software-properties-common' # Required in ubuntu 14.04 for add-apt-repository command

    apt_key_accept "keyserver.ubuntu.com" "A1715D88E1DF1F24" # Git
    apt_ppa_add 'git-core/ppa' "Git (add PPA)"

    if [[ $? -eq 0 ]]; then
      update_ubuntu
    fi

    apt_install 'Git' 'git'

    if [[ -n "${http_proxy}" ]]; then
      ask_for_confirmation 'Do you want to use existing Proxy settings for Git (global)?'

      if answer_is_yes; then
        save_proxy_settings_to_git
      fi
    fi

    touch ~/.dotfiles/.git_installed
    echo "created: ~/.dotfiles/.git_installed" >> ~/.dotfiles.log
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  install_bash4x() {
    # Tools for compiling/building software from source
    apt_install 'Build Essential' 'build-essential' # Installs make, which is used for bash 4.3 setup

    download "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz" ~/.bash-4.3.tar.gz

    if [[ $? -ne 1 ]]; then
      if grep -q 'Not found' ~/.bash-4.3.tar.gz; then
        print_error "Downloading bash 4.3 tarball failed"
      fi

      if [[ ! -d ~/.bash-4.3 ]]; then
        mkdir -v ~/.bash-4.3 &>> ~/.dotfiles.log
      fi

      tar -xzvf ~/.bash-4.3.tar.gz --strip-components 1 -C ~/.bash-4.3 &>> ~/.dotfiles.log

      if [[ $? -eq 1 ]]; then
        print_error "Extracting tarball failed"
      else
        cd ~/.bash-4.3

        ./configure &>> ~/.dotfiles.log

        make &>> ~/.dotfiles.log
        sudo make install &>> ~/.dotfiles.log

        print_result $? "Bash 4.3"

        chsh -s "/bin/bash"

        print_result $? 'Set version of Bash to use 4.3'

        rm -v ~/.bash-4.3.tar.gz &>> ~/.dotfiles.log
        sudo rm -vfR ~/.bash-4.3 &>> ~/.dotfiles.log

        cd "$cwd"
      fi
    fi

    touch ~/.dotfiles/.bash4x_installed
    echo "created: ~/.dotfiles/.bash4x_installed" >> ~/.dotfiles.log
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ask_for_confirmation "Do you want to install all applications? (y)es for all, (n)o for individual app selection)";

  if answer_is_yes; then
    install_all="Y"
  else
    ask_install_or_update "bash4x"    "Bash 4.3"                "install_bash4x"
    ask_install_or_update "git"       "Git"                     "install_git"
    ask_install_or_update "curl"      "Curl"                    "install_curl"
    ask_install_or_update "tmux"      "Tmux"                    "install_tmux"
    ask_install_or_update "zopfli"    "Zopfli compression lib"  "install_zopfli"
    ask_install_or_update "vim-gnome" "Vim"                     "install_vim"
    ask_install_or_update "xclip"     "XClip (clipboard)"       "install_xclip"
    ask_install_or_update "zip"       "Zip"                     "install_zip"
    ask_install_or_update "sshpass"   "SSH Pass"                "install_sshpass"
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  update_ubuntu

  # GnuPG archive keys of the Debian archive
  apt_install 'GnuPG archive keys' 'debian-archive-keyring'

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Allow un-authenticated Apt repositories to install software
  # Required for latest git version (default apt version is 1.7 - too low)
  # Required for java core team ppa

  echo 'APT::Get::AllowUnauthenticated 1;' | sudo tee "/etc/apt/apt.conf.d/02allow-unsigned" &>> ~/.dotfiles.log

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  install_or_update "bash4x"    "Bash 4.3"                "install_bash4x"
  install_or_update "git"       "Git"                     "install_git"
  install_or_update "curl"      "Curl"                    "install_curl"
  install_or_update "tmux"      "Tmux"                    "install_tmux"
  install_or_update "tmux"      "Zopfli compression lib"  "install_zopfli"
  install_or_update "vim-gnome" "GNOME Vim"               "install_vim"
  install_or_update "xclip"     "XClip (clipboard)"       "install_xclip"
  install_or_update "zip"       "Zip"                     "install_zip"
  install_or_update "sshpass"   "SSH Pass"                "install_sshpass"

  cd "${pwd}"
}

ubuntu_install_applications

unset ubuntu_install_applications
