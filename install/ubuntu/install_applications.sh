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
  local install_ant=false
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
    install_ant=true
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

    ask_for_confirmation "Do you want to install Apache Ant?";

    if answer_is_yes; then
      install_ant=true
    fi

    ask_for_confirmation "Do you want to install SSH Pass?";

    if answer_is_yes; then
      install_ssh=true
    fi
  fi

  update_ubuntu

  # Simple configuration storage system
  apt_install 'GSettings' 'libglib2.0-bin'

  # Tools for compiling/building software from source
  apt_install 'Build Essential' 'build-essential'

  # GnuPG archive keys of the Debian archive
  apt_install 'GnuPG archive keys' 'debian-archive-keyring'

  apt_install 'Common Software Properties' 'software-properties-common'

  apt_install 'Python Software Properties' 'python-software-properties'

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Allow un-authenticated Apt repositories to install software
  # Required for latest git version (default apt version is 1.7 - too low)
  # Required for java core team ppa

  echo 'APT::Get::AllowUnauthenticated 1;' | sudo tee "/etc/apt/apt.conf.d/02allow-unsigned" > /dev/null 2>&1

  if [[ "${install_git}" == true ]]; then
    if ! is_callable 'git'; then
      apt_key_accept "keyserver.ubuntu.com" "A1715D88E1DF1F24" # Git
      apt_ppa_add 'git-core/ppa' "Git (add PPA)"
    fi
  fi

  update_ubuntu

  if [[ "${install_bash4x}" == true ]]; then
    wget --no-check-certificate -qO ~/.bash-4.3.tar.gz "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz" && ! grep -q 'Not found' ~/.bash-4.3.tar.gz \
        || ( print_error "Downloading bash 4.3 tarball failed" && exit 1 )

    tar -xf ~/.bash-4.3.tar.gz --strip-components 1 -C ~/.bash-4.3 &> /dev/null \
        || ( print_error "Extracting tarball failed" && exit 1 )

    cd ~/.bash-4.3

    ./configure &> /dev/null

    make &> /dev/null
    sudo make install &> /dev/null

    print_success "Bash 4.3"

    chsh -s "/bin/bash" &> /dev/null

    print_result $? 'Set version of Bash to use 4.3'

    rm ~/.bash-4.3.tar.gz &> /dev/null
    rm -R ~/.bash-4.3 &> /dev/null

    cd "$(dirname "${0}")"
  fi

  if [[ "${install_git}" == true ]]; then
    apt_install 'Git' 'git'
  fi

  if [[ "${install_git}" == true ]]; then
    apt_install 'Git' 'git'
  fi

  if [[ "${install_curl}" == true ]]; then
    apt_install 'cURL' 'curl'
  fi

  if [[ "${install_tmux}" == true ]]; then
    apt_install 'tmux' 'tmux'
  fi

  if [[ "${install_vim}" == true ]]; then
    apt_install 'GNOME Vim' 'vim-gnome'
  fi

  if [[ "${install_xclip}" == true ]]; then
    apt_install 'xclip' 'xclip'
  fi

  if [[ "${install_zip}" == true ]]; then
    apt_install 'Zip' 'zip'
  fi

  if [[ "${install_ant}" == true ]]; then
    apt_install 'Apache Ant' 'ant'
  fi

  if [[ "${install_ssh}" == true ]]; then
    apt_install 'SSHPass' 'sshpass'
  fi

  cd "${pwd}"
}

ubuntu_install_applications

unset ubuntu_install_applications
