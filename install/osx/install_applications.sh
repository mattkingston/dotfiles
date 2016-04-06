#!/usr/bin/env bash

osx_install_applications() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local install_xcode=false
  local install_brew=false
  local install_bash4x=false
  local install_git=false
  local install_curl=false
  local install_tmux=false
  local install_zopfli=false
  local install_webfonttools=false
  local install_vim=false
  local install_openssl=false
  local install_gfx=false
  local install_unarchiver=false
  local install_keyboardclean=false
  local install_avast=false
  local install_brave=false
  local install_flash=false
  local install_alfred=false
  local install_divvy=false
  local install_evernote=false
  local install_things=false
  local install_reader=false
  local install_adobe_cloud=false
  local install_vbox=false
  local install_vagrant=false

  ask_for_confirmation "Do you want to install all applications? (y)es for all, (n)o for individual app selection)";

  if answer_is_yes; then
    install_xcode=true
    install_brew=true
    install_bash4x=true
    install_git=true
    install_curl=true
    install_tmux=true
    install_zopfli=true
    install_webfonttools=true
    install_vim=true
    install_openssl=true
    install_gfx=true
    install_unarchiver=true
    install_keyboardclean=true
    install_avast=true
    install_brave=true
    install_flash=true
    install_alfred=true
    install_divvy=true
    install_evernote=true
    install_things=true
    install_reader=true
    install_adobe_cloud=true
    install_vbox=true
    install_vagrant=true
  else
    ask_for_confirmation "Do you want to install XCode?";

    if answer_is_yes; then
      install_xcode=true
    fi

    ask_for_confirmation "Do you want to install Homebrew?";

    if answer_is_yes; then
      install_brew=true
    fi

    ask_for_confirmation "Do you want to install Bash 4.3?";

    if answer_is_yes; then
      install_bash4x=true
    fi

    ask_for_confirmation "Do you want to install Git?";

    if answer_is_yes; then
      install_git=true
    fi

    ask_for_confirmation "Do you want to install cURL?";

    if answer_is_yes; then
      install_curl=true
    fi

    ask_for_confirmation "Do you want to install tmux?";

    if answer_is_yes; then
      install_tmux=true
    fi

    ask_for_confirmation "Do you want to install Zopfli compression lib?";

    if answer_is_yes; then
      install_zopfli=true
    fi

    ask_for_confirmation "Do you want to install the Web font tools?";

    if answer_is_yes; then
      install_webfonttools=true
    fi

    ask_for_confirmation "Do you want to install VIM?";

    if answer_is_yes; then
      install_vim=true
    fi

    ask_for_confirmation "Do you want to install OpenSSL?";

    if answer_is_yes; then
      install_openssl=true
    fi

    ask_for_confirmation "Do you want to install GFX Card Status?";

    if answer_is_yes; then
      install_gfx=true
    fi

    ask_for_confirmation "Do you want to install Unarchiver?";

    if answer_is_yes; then
      install_unarchiver=true
    fi

    ask_for_confirmation "Do you want to install Keyboard Cleaner?";

    if answer_is_yes; then
      install_keyboardclean=true
    fi

    ask_for_confirmation "Do you want to install Avast?";

    if answer_is_yes; then
      install_avast=true
    fi

    ask_for_confirmation "Do you want to install Brave?";

    if answer_is_yes; then
      install_brave=true
    fi

    ask_for_confirmation "Do you want to install Flash Plugin?";

    if answer_is_yes; then
      install_flash=true
    fi

    ask_for_confirmation "Do you want to install Alfred?";

    if answer_is_yes; then
      install_alfred=true
    fi

    ask_for_confirmation "Do you want to install Divvy?";

    if answer_is_yes; then
      install_divvy=true
    fi

    ask_for_confirmation "Do you want to install Evernote?";

    if answer_is_yes; then
      install_evernote=true
    fi

    ask_for_confirmation "Do you want to install Things?";

    if answer_is_yes; then
      install_things=true
    fi

    ask_for_confirmation "Do you want to install Adobe Reader?";

    if answer_is_yes; then
      install_reader=true
    fi

    ask_for_confirmation "Do you want to install Adobe Cloud?";

    if answer_is_yes; then
      install_adobe_cloud=true
    fi

    ask_for_confirmation "Do you want to install VirtualBox?";

    if answer_is_yes; then
      install_vbox=true
    fi

    ask_for_confirmation 'Do you want to install Vagrant?'

    if answer_is_yes; then
      install_vagrant=true
    fi
  fi

  if [[ "${install_xcode}" == true ]]; then
    ./install_xcode.sh
  fi

  if [[ "${install_brew}" == true ]]; then
    if ! xcode-select -p &> /dev/null; then
      print_error "XCode is required to install Homebrew on OSX"
      exit 1
    fi

    if ! cmd_exists 'brew'; then
      printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
    fi

    print_result $? 'Homebrew'
  fi

  if ! cmd_exists 'brew'; then
    print_error "Homebrew is required to install applications on OSX"
    exit 1
  fi

  brew_tap 'caskroom/versions'

  if [[ "${install_bash4x}" == true ]]; then
    ./install_latest_bash.sh
  fi

  if [[ "${install_git}" == true ]]; then
    brew_install 'Git' 'git'
  fi

  if [[ "${install_curl}" == true ]]; then
    brew_install 'Curl' 'curl'
  fi

  if [[ "${install_tmux}" == true ]]; then
    brew_install 'tmux' 'tmux'
    touch ~/.dotfiles/.tmux_installed
  fi

  if [[ "${install_zopfli}" == true ]]; then
    brew_install 'Zopfli' 'zopfli'
  fi

  if [[ "${install_webfonttools}" == true ]]; then
    brew_tap 'bramstein/webfonttools'

    brew_install 'TTF/OTF → WOFF' 'sfnt2woff'
    brew_install 'WOFF2' 'woff2'
  fi

  if [[ "${install_vim}" == true ]]; then
    brew_install 'Vim' 'vim --override-system-vi'
    touch ~/.dotfiles/.vim_installed
  fi

  if [[ "${install_openssl}" == true ]]; then
    brew_install 'OpenSSL' 'openssl'
  fi

  brew_install 'Bash Completion 2' 'bash-completion2'

  if [[ "${install_gfx}" == true ]]; then
    brew_install 'GFX Card Status' 'gfxcardstatus' 'cask'
  fi

  if [[ "${install_unarchiver}" == true ]]; then
    brew_install 'Unarchiver' 'the-unarchiver' 'cask'
  fi

  if [[ "${install_keyboardclean}" == true ]]; then
    brew_install 'Keyboard Cleaner' 'keyboard-cleaner' 'cask'
  fi

  if [[ "${install_avast}" == true ]]; then
    brew_install 'Avast Security' 'avast' 'cask'
  fi

  if [[ "${install_brave}" == true ]]; then
    brew_install 'Brave' 'brave' 'cask'
  fi

  if [[ "${install_flash}" == true ]]; then
    brew_install 'Flash' 'flash' 'cask'
  fi

  if [[ "${install_alfred}" == true ]]; then
    brew_install 'Alfred' 'alfred' 'cask'
  fi

  if [[ "${install_divvy}" == true ]]; then
    brew_install 'Divvy' 'divvy' 'cask'
  fi

  if [[ "${install_evernote}" == true ]]; then
    brew_install 'Evernote' 'evernote' 'cask'
  fi

  if [[ "${install_things}" == true ]]; then
    brew_install 'Things' 'things' 'cask'
  fi

  if [[ "${install_reader}" == true ]]; then
    brew_install 'Adobe Reader' 'adobe-reader' 'cask'
  fi

  if [[ "${install_adobe_cloud}" == true ]]; then
    brew_install 'Adobe Cloud' 'adobe-creative-cloud' 'cask'
  fi

  if [[ "${install_vbox}" == true ]]; then
    brew_install 'VirtualBox' 'virtualbox' 'cask'
  fi

  if [[ "${install_vagrant}" == true ]]; then
    brew_install 'Vagrant' 'vagrant' 'cask'

    if ! ( vagrant plugin list | grep -q 'vagrant-env' ); then
      vagrant plugin install vagrant-env --plugin-source http://rubygems.org > /dev/null

      print_result $? "Vagrant env plugin"
    fi

    if ! ( vagrant plugin list | grep -q 'vagrant-vbguest' ); then
      vagrant plugin install vagrant-vbguest --plugin-source http://rubygems.org > /dev/null

      print_result $? "Vagrant vbguest plugin"
    fi

    if ! ( vagrant plugin list | grep -q 'vagrant-proxyconf' ); then
      vagrant plugin install vagrant-proxyconf --plugin-source http://rubygems.org > /dev/null

      print_result $? "Vagrant proxyconf plugin"
    fi

    if ! ( vagrant plugin list | grep -q 'vagrant-puppet-install' ); then
      vagrant plugin install vagrant-puppet-install --plugin-source http://rubygems.org > /dev/null

      print_result $? "Vagrant puppet-install plugin"
    fi

    if ! ( vagrant plugin list | grep -q 'vagrant-timezone' ); then
      vagrant plugin install vagrant-timezone --plugin-source http://rubygems.org > /dev/null

      print_result $? "Vagrant timezone plugin"
    fi
  fi

  execute 'brew cleanup | dotfiles_log' 'brew (cleanup)'
  execute 'brew cask cleanup | dotfiles_log' 'brew cask (cleanup)'

  cd "${pwd}"
}

osx_install_applications

unset osx_install_applications
