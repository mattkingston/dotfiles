#!/usr/bin/env bash

osx_install_latest_bash() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")";

  . ~/.dotfiles/bin/dotfiles

  local HOMEBREW_PREFIX=''

  # Check if `Homebrew` is installed

#  if ! cmd_exists 'brew'; then
#    print_error 'Homebrew is required, please install it!\n'
#    exit 1
#  fi

  brew_install 'Bash 4.3' 'bash'

  # Check is `Bash 4.x` is installed

  if ! brew list bash &> /dev/null; then
    exit 1
  fi

  # Add the path of the Bash version installed through Homebrew
  # to the list of login shells from the `/etc/shells` file.
  #
  # This needs to be done because applications use this file to
  # determine whether a shell is valid (e.g.: `chsh` consults the
  # `/etc/shells` to determine whether an unprivileged user may
  # change the login shell for her own account).
  #
  # http://www.linuxfromscratch.org/blfs/view/7.4/postlfs/etcshells.html

  HOMEBREW_PREFIX="$(brew --prefix)"

  if [ -z "$(cat /etc/shells | grep "$HOMEBREW_PREFIX")" ]; then
    sudo sh -c "printf \"$HOMEBREW_PREFIX/bin/bash\n\" >> /etc/shells"
    print_result $? "Add \`$HOMEBREW_PREFIX/bin/bash\` in \`/etc/shells\`"
  fi

  # Make OS X use the Bash version installed through Homebrew
  # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/chsh.1.html

  chsh -s "$HOMEBREW_PREFIX"/bin/bash &>> ~/.dotfiles.log

  print_result $? 'Set version of Bash to use 4.3'

  cd "${pwd}"
}

osx_install_latest_bash

unset osx_install_latest_bash
