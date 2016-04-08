#!/usr/bin/env bash

declare GIT_REMOTE="http://github.com/mattkingston/dotfiles.git"
declare TARBALL_URL="http://github.com/mattkingston/dotfiles/tarball/master"

# Main

setup() {
  local pwd="$(pwd)"
  local backup_suffix="$(date "+%Y-%m-%d-%H-%M-%S")"

  echo "" > ~/.dotfiles.log # Truncate log before each attempt
  printf "\n\n\n\n\n       %s\n\n\n\n\n" "---- SETUP BEGAN: $(date "+%Y-%m-%d %H:%M:%S") ----" | tee ~/.dotfiles.log &> /dev/null

  if [[ "$BASH_SOURCE" == "" ]]; then
    # Backup first
    if [[ -e ~/.dotfiles ]]; then
      mv -v ~/.dotfiles ~/.dotfiles.backup-"$backup_suffix" &>> ~/.dotfiles.log
    fi

    # Download tarball
    if command -v 'curl' > /dev/null; then
      curl -Lko ~/.dotfiles.tar.gz "${TARBALL_URL}" &>> ~/.dotfiles.log

      if [[ $? -ne 1 ]]; then
        if grep -q 'Not found' ~/.dotfiles.tar.gz &>> ~/.dotfiles.log; then
          printf "\e[38;5;124m%s\n\e[0m" "Downloading dotfiles tarball failed"
          printf "ERROR: %s" "Downloading dotfiles tarball failed" >> ~/.dotfiles.log
          exit 1
        fi
      fi

    elif command -v 'wget' > /dev/null; then
      wget --no-check-certificate -O ~/.dotfiles.tar.gz "${TARBALL_URL}" &>> ~/.dotfiles.log

      if [[ $? -ne 1 ]]; then
        if grep -q 'Not found' ~/.dotfiles.tar.gz &>> ~/.dotfiles.log; then
          printf "\e[38;5;124m%s\n\e[0m" "Downloading dotfiles tarball failed"
          printf "ERROR: %s" "Downloading dotfiles tarball failed" >> ~/.dotfiles.log
          exit 1
        fi
      fi

    else
      printf "\e[38;5;124m%s\n\e[0m" "'curl' or 'wget' binaries required"
      printf "ERROR: %s" "'curl' or 'wget' binaries required" >> ~/.dotfiles.log
      exit 1
    fi

    # Extract tarball
    if ! command -v 'tar' > /dev/null; then
      printf "\e[38;5;124m%s\n\e[0m" "'tar' binary required"
      exit 1
    else
      if [[ ! -d ~/.dotfiles ]]; then
        mkdir -v ~/.dotfiles &>> ~/.dotfiles.log
      fi

      tar -xzf ~/.dotfiles.tar.gz --strip-components 1 -C ~/.dotfiles &>> ~/.dotfiles.log

      if [[ $? -eq 1 ]]; then
        printf "\e[38;5;124m%s\n\e[0m" "Extracting tarball failed"
        printf "ERROR: %s" "Extracting tarball failed" >> ~/.dotfiles.log
        exit 1
      fi
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
    echo "created $BASH_RC_LOCAL" | dotfiles_log
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
      echo "created ~/.$i" | dotfiles_log
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

    ask_for_confirmation 'Do you want to use insecure curl (helpful if you are behind a MiM proxy server)?'

    if answer_is_yes; then
      if ! grep -q "insecure" "$CURL_RC"; then
        echo "insecure" >> "$CURL_RC"
        echo "\"insecure\" added to $CURL_RC" >> ~/.dotfiles.log
      fi
    fi
  else
    ask_for_confirmation 'Do you want to set up Proxy details now?'

    if answer_is_yes; then
      ask_proxy_settings && save_proxy_settings
    fi

    ask_for_confirmation 'Do you want to use insecure curl (helpful if you are behind a MiM proxy server)?'

    if answer_is_yes; then
      if ! grep -q "insecure" "$CURL_RC"; then
        echo "insecure" >> "$CURL_RC"
        echo "\"insecure\" added to $CURL_RC" >> ~/.dotfiles.log
      fi
    fi
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  print_title 'Applications'

  ask_for_confirmation 'Do you want to install OS applications?'

  if answer_is_yes; then
    ./install/install_applications.sh
  fi

  cd ~/.dotfiles

  print_subtitle 'Copy app dotfiles'
  ask_for_confirmation 'Do you want to copy app dotfiles?'

  if answer_is_yes; then
    if [[ "$BASH_SOURCE" == "" ]]; then
      ./install/copy_applications_dotfiles.sh "$backup_suffix"
    else
      ./install/copy_applications_dotfiles.sh
    fi
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

    git config --file "$GIT_CONF_LOCAL" http.sslverify false &>> ~/.dotfiles.log

    if [[ "$git_username" != "" ]]; then
      git config --file "$GIT_CONF_LOCAL" user.name "$git_username" &>> ~/.dotfiles.log
    fi

    if [[ "$git_email" != "" ]]; then
      git config --file "$GIT_CONF_LOCAL" user.email "$git_email" &>> ~/.dotfiles.log
    fi
  fi

  if is_callable 'git'; then
    print_subtitle 'NVM'

    ask_for_confirmation 'Do you want to install NVM?'

    if answer_is_yes; then
      ./install/install_nvm.sh
    fi

    . ~/.dotfiles/bash/autocomplete.sh

    if command -v "npm" > /dev/null || type -t "npm" > /dev/null; then
      print_subtitle 'Global NPM Packages'

      ask_for_confirmation 'Do you want to install global npm packages?'

      if answer_is_yes; then
        ./install/install_npm_packages.sh
      fi

      . ~/.dotfiles/bash/autocomplete.sh
    fi
  fi


  print_subtitle 'RVM'

  ask_for_confirmation 'Do you want to install RVM?'

  if answer_is_yes; then
    ./install/install_rvm.sh
    . ~/.dotfiles/bash/autocomplete.sh
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if cmd_exists 'vim' && [[ -f ~/.dotfiles/.vim_installed ]]; then
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
