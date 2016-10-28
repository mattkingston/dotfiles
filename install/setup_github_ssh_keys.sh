#!/usr/bin/env bash

set_github_ssh_key() {
  local pwd="$(pwd)"

  . ~/.dotfiles/bin/dotfiles

  local github_ssh_url='https://github.com/settings/ssh'
  local ssh_key_file='id_rsa.pub'
  
  if [[ ! -d ~/.ssh ]]; then
    mkdir ~/.ssh
  fi

  cd ~/.ssh

  # Setup GitHub SSH Key
  # https://help.github.com/articles/generating-ssh-keys

  print_info 'Set up the SSH key'

  if [ ! -r "${ssh_key_file}" ]; then
    rm -rf "${ssh_key_file}" &> /dev/null
    ask 'Please provide an email address for ssh key file: ' && printf '\n'
    ssh-keygen -t rsa -C "$(get_answer)"
  fi

  if cmd_exists 'open' && cmd_exists 'pbcopy'; then
    # Copy SSH key to clipboard
    cat "${ssh_key_file}" | pbcopy

    print_result $? "Copy SSH key to clipboard"

    # Open the GitHub web page where the SSH key can be added
    open "${github_ssh_url}"
  elif cmd_exists 'xclip' && cmd_exists 'xdg-open'; then
    # Copy SSH key to clipboard
    cat "$ssh_key_file" | xclip -selection clip

    print_result $? "Copy SSH key to clipboard"

    # Open the GitHub web page where the SSH key can be added
    xdg-open "${github_ssh_url}"
  fi

  print_info "Please log into Github and paste the key into the SSH Keys list"

  while true; do
    ssh -T git@github.com &> /dev/null
    [ $? -eq 1 ] && break
    sleep 5
    print_info " ... Attempting SSH connection to Github"
  done

  print_success 'Set up the SSH key'

  cd "${pwd}"
}

set_github_ssh_key

unset set_github_ssh_key
