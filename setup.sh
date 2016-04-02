#!/usr/bin/env bash

declare GIT_REMOTE="http://github.com/mattkingston/dotfiles-v2.git"
declare TARBALL_URL="http://github.com/mattkingston/dotfiles-v2/tarball/master"

# Main

setup() {
  local pwd="$(pwd)"
  local backup_suffix="$(date +%Y-%m-%d-%H-%M-%S)"

  if [[ "$BASH_SOURCE" == "" ]]; then
    # Backup first
    if [[ -d ~/.dotfiles ]]; then
      mv ~/.dotfiles ~/.dotfiles.backup-"$backup_suffix"
    fi

    # Download tarball
    if command -v 'curl' > /dev/null; then
      curl -LsSko ~/.dotfiles.tar.gz "${TARBALL_URL}" && ! grep -q 'Not found' ~/.dotfiles.tar.gz \
        || ( printf "\e[38;5;124m%s\n\e[0m" "Downloading dotfiles tarball failed" && exit 1 )
    elif command -v 'wget' > /dev/null; then
      wget --no-check-certificate -qO ~/.dotfiles.tar.gz "${TARBALL_URL}" && ! grep -q 'Not found' ~/.dotfiles.tar.gz \
        || ( printf "\e[38;5;124m%s\n\e[0m" "Downloading dotfiles tarball failed" && exit 1 )
    else
      printf "\e[38;5;124m%s\n\e[0m" "'curl' or 'wget' binaries required" \
        && exit 1
    fi

    # Extract tarball
    if ! command -v 'tar' > /dev/null; then
      printf "\e[38;5;124m%s\n\e[0m" "'tar' binary required" \
        && exit 1
    else
      tar -xf ~/.dotfiles.tar.gz --strip-components 1 -C ~/.dotfiles &> /dev/null \
        || ( printf "\e[38;5;124m%s\n\e[0m" "Extracting tarball failed" && exit 1 )
    fi
  fi

  # Source some important pieces just like in ~/.bashrc
  # . ~/.dotfiles/bash/options.sh
  # . ~/.dotfiles/bash/exports.sh

  # For convenience and performance - opposed to calling dotfiles before each lib command
  . ~/.dotfiles/bin/dotfiles

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if ! is_supported_os; then
    print_error '%s' "Ubuntu => '$(get_supported_ubuntu_version)' or OSX => '$(get_supported_osx_version)' are required."
    exit 1
  fi

  if [[ ! -e "${BASH_RC_LOCAL}" ]]; then
    touch "${BASH_RC_LOCAL}"
    print_result $? "${BASH_RC_LOCAL}"
  fi

  ask_for_sudo

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd ~/.dotfiles

  # Dotfiles locals

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local locals=(
    "$BASH_RC_LOCAL"
    "$GIT_CONF_LOCAL"
    "$MYVIMRC_LOCAL"
    "$MYGVIMRC_LOCAL"
  )

  for i in "${local[@]}"; do
    if [[ ! -e ~/."${i}" ]]; then
      touch ~/."${i}"
      print_result $? "~/.${i}"
    fi
  done

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  print_title 'Home directory'

  print_subtitle 'Copy dotfiles'
  ask_for_confirmation 'Do you want to copy dotfiles?'

  if answer_is_yes; then
    if [[ "$BASH_SOURCE" == "" ]]; then
      ./install/copy_dotfiles.sh "$backup_suffix"
    else
      ./install/copy_dotfiles.sh
    fi
  fi

  print_title 'Proxy'

  if is_param_defined 'proxy' "${argument_list[@]}"; then
    parse_proxy_from_url "$(get_param_value 'proxy' "${argument_list[@]}")"

    confirm_proxy_settings

    if answer_is_yes; then
      save_proxy_settings
    else
      ask_for_confirmation 'Do you want to set up Proxy details now?'

      if answer_is_yes; then
        ask_proxy_settings && save_proxy_settings
      fi
    fi
  else
    ask_for_confirmation 'Do you want to set up Proxy details now?'

    if answer_is_yes; then
      ask_proxy_settings && save_proxy_settings
    fi
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  print_title 'Applications'

  ask_for_confirmation 'Do you want to install OS applications?'

  if answer_is_yes; then
    ./install/install_applications.sh
  fi

  if is_callable 'git'; then

    local git_username=""
    local git_email=""

    ask_for_confirmation "Do you want to set Git user settings now?";

    if answer_is_yes; then
      while true; do
        ask 'Please enter your name'
        git_username="$(get_answer)"

        ask 'Please enter your email'
        git_email="$(get_answer)"

        print_subtitle "Git settings are:"

        printf "\n"

        printf '   user.name = %s \n' "$git_username"
        printf '  user.email = %s \n' "$git_email"

        ask_for_confirmation "Are these correct?"

        if answer_is_yes; then
          break
        else
          ask_for_confirmation "Try setting Git user settings again?"

          if ! answer_is_yes; then
            break
          fi
        fi
      done
    fi

    git config --file "$GIT_CONF_LOCAL" http.sslverify false

    if [[ "$git_username" != "" ]]; then
      git config --file "$GIT_CONF_LOCAL" user.name "$git_username"
    fi

    if [[ "$git_email" != "" ]]; then
      git config --file "$GIT_CONF_LOCAL" user.email "$git_email"
    fi
  fi

  print_subtitle 'NVM'

  ask_for_confirmation 'Do you want to install NVM?'

  if answer_is_yes; then
    ./install/install_nvm.sh
  fi

  . ~/.dotfiles/bash/autocomplete.sh

  print_subtitle 'Global NPM Packages'

  ask_for_confirmation 'Do you want to install global npm packages?'

  if answer_is_yes; then
    ./install/install_npm_packages.sh
  fi

  . ~/.dotfiles/bash/autocomplete.sh

  print_subtitle 'RVM'

  ask_for_confirmation 'Do you want to install RVM?'

  if answer_is_yes; then
    ./install/install_rvm.sh
  fi

  . ~/.dotfiles/bash/autocomplete.sh

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if cmd_exists 'vim'; then
    print_subtitle 'Install/Update Vim plugins'

    ask_for_confirmation 'Do you want to install/update the Vim plugins?'

    if answer_is_yes; then
      vim_reinstall_plugins
    fi
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  print_title 'Preferences'

  ask_for_confirmation 'Do you want to set the custom preferences?'

  if answer_is_yes; then
    ./install/set_preferences.sh
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  print_title 'GitHub'

  ask_for_confirmation 'Do you want to set up Github SSH keys?'

  if answer_is_yes; then
    ./install/setup_github_ssh_keys.sh
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ssh -T git@github.com &> /dev/null

  if [[ $? -ne 1 ]]; then
    if ! is_running_locally && cmd_exists 'git' && ! is_git_repository; then
      if [[ "$(git config --get remote.origin.url)" != "$(get_dotfiles_origin)" ]]; then
        print_subtitle "Dotfiles"

        print_info 'Initialize Git repository'

        git init &> /dev/null \
          && git remote add origin "$(get_dotfiles_origin)" &> /dev/null

        print_result $? 'Initialize the Git repository'
      fi
    fi
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  print_title 'Restart'

  if [ "$(whoami)" == "vagrant" ]; then
    print_success "Provisioning complete\n"
    print_info 'An updated shell is required. Please exit from this Vagrant VM and re-ssh in'
  else
    ask_for_confirmation 'Do you want to restart?'

    if answer_is_yes; then
      sudo shutdown -r now &> /dev/null
    else
      print_success "Provisioning complete\n"
    fi
  fi

  cd "${pwd}"
}

setup "$@"

unset setup
unset GIT_REMOTE
unset TARBALL_URL