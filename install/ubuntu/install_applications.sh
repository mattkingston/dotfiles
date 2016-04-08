#!/usr/bin/env bash

ubuntu_install_applications() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local install_bash4x=false
  local install_git=false
  local install_tmux=false
  local install_curl=false
  local install_zopfli=false
  local install_vim=false
  local install_xclip=false
  local install_zip=false
  local install_ssh=false

  local git_username=""
  local git_email=""

  ask_for_confirmation "Do you want to install all applications? (y)es for all, (n)o for individual app selection)";

  if answer_is_yes; then
    install_bash4x=true
    install_git=true
    install_tmux=true
    install_curl=true
    install_zopfli=true
    install_vim=true
    install_xclip=true
    install_zip=true
    install_ssh=true
  else
    ask_for_confirmation "Do you want to install Bash 4.3?";

    if answer_is_yes; then
      install_bash4x=true
    fi

    ask_for_confirmation "Do you want to install Git?";

    if answer_is_yes; then
      install_git=true
    fi

    ask_for_confirmation "Do you want to install tmux?";

    if answer_is_yes; then
      install_tmux=true
    fi

    ask_for_confirmation "Do you want to install cURL?";

    if answer_is_yes; then
      install_curl=true
    fi

    ask_for_confirmation "Do you want to install Zopfli compression lib?";

    if answer_is_yes; then
      install_zopfli=true
    fi

    ask_for_confirmation "Do you want to install Vim?";

    if answer_is_yes; then
      install_vim=true
    fi

    ask_for_confirmation "Do you want to install xclip?";

    if answer_is_yes; then
      install_xclip=true
    fi

    ask_for_confirmation "Do you want to install Zip?";

    if answer_is_yes; then
      install_zip=true
    fi

    ask_for_confirmation "Do you want to install SSH Pass?";

    if answer_is_yes; then
      install_ssh=true
    fi
  fi

  update_ubuntu

  # GnuPG archive keys of the Debian archive
  # apt_install 'GnuPG archive keys' 'debian-archive-keyring' 

  # apt_install 'Common Software Properties' 'software-properties-common' # installs python (v3) & common-ca-certificates

  # apt_install 'Python Software Properties' 'python-software-properties'

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Allow un-authenticated Apt repositories to install software
  # Required for latest git version (default apt version is 1.7 - too low)
  # Required for java core team ppa

  echo 'APT::Get::AllowUnauthenticated 1;' | sudo tee "/etc/apt/apt.conf.d/02allow-unsigned" &>> ~/.dotfiles.log

  if [[ "${install_git}" == true ]]; then
    apt_install 'Python Software Properties' 'python-software-properties' # Required in ubuntu 12.04 for add-apt-repository command
    apt_install 'Common Software Properties' 'software-properties-common' # Required in ubuntu 14.04 for add-apt-repository command

    apt_key_accept "keyserver.ubuntu.com" "A1715D88E1DF1F24" # Git
    apt_ppa_add 'git-core/ppa' "Git (add PPA)"

    if [[ $? -eq 0 ]]; then
      update_ubuntu
    fi
  fi

  if [[ "${install_bash4x}" == true ]]; then
    # Tools for compiling/building software from source
    apt_install 'Build Essential' 'build-essential' # Installs make, which is used for bash 4.3 setup

    wget --no-check-certificate -O ~/.bash-4.3.tar.gz "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz" &>> ~/.dotfiles.log

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
        sudo rm -vR ~/.bash-4.3 &>> ~/.dotfiles.log

        cd "$(dirname "${0}")"
      fi
    fi

  fi

  if [[ "${install_git}" == true ]]; then
    apt_install 'Git' 'git'

    if [[ "$http_proxy" -ne "" ]]; then
      ask_for_confirmation 'Do you want to use existing Proxy settings for Git (global)?'

      if answer_is_yes; then
        save_proxy_settings_to_git
      fi
    fi
  fi

  if [[ "${install_curl}" == true ]]; then
    apt_install 'cURL' 'curl'
  fi

  if [[ "${install_tmux}" == true ]]; then
    apt_install 'tmux' 'tmux'
    touch ~/.dotfiles/.tmux_installed
    echo "created: ~/.dotfiles/.tmux_installed" >> ~/.dotfiles.log
  fi

  if [[ "${install_vim}" == true ]]; then
    apt_install 'GNOME Vim' 'vim-gnome'
    touch ~/.dotfiles/.vim_installed
    echo "created: ~/.dotfiles/.vim_installed" >> ~/.dotfiles.log
  fi

  if [[ "${install_xclip}" == true ]]; then
    apt_install 'xclip' 'xclip'
  fi

  if [[ "${install_zip}" == true ]]; then
    apt_install 'Zip' 'zip'
  fi

  if [[ "${install_ssh}" == true ]]; then
    apt_install 'SSHPass' 'sshpass'
  fi

  cd "${pwd}"
}

ubuntu_install_applications

unset ubuntu_install_applications
