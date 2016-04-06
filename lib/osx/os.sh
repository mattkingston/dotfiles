#!/usr/bin/env bash

# OSX OS utils

brew_install() {
  local command="${3}"
  local formula="${2}"
  local formula_name="${1}"

  if [[ "$command" == "" ]]; then
    brew list $formula | dotfiles_log

    [[ "${PIPESTATUS[0]}" -eq 0 ]] \
      && print_success "${formula_name}" \
      || execute "brew $command install $formula | dotfiles_log" "${formula_name}"
  else
    brew $command list $formula | dotfiles_log

    [[ "$PIPESTATUS[0]" -eq 0 ]] \
      && print_success "${formula_name}" \
      || execute "brew $command install $formula | dotfiles_log" "${formula_name}"
  fi
}

brew_link() {
  local command="${3}"
  local formula="${2}"
  local formula_name="${1}"

  brew list $formula | dotfiles_log

  [[ "$PIPESTATUS[0]" -eq 0 ]] \
    && execute "brew link $formula | dotfiles_log" "$formula_name"
}

brew_tap() {
  local repository="$1"

  brew tap | grep -q "$repository" \
    && print_success "tap: ${repository}" \
    || execute "brew tap ${repository} | dotfiles_log" "tap: ${repository}"
}

brew_list() {
  local command="${2}"
  local formula="${1}"

  brew $command list $formula | dotfiles_log

  [[ "$PIPESTATUS[0]" -eq 0 ]] \
    && return 0 \
    || return 1;
}

update_osx() {
  # System software update tool
  # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/softwareupdate.8.html
  sudo softwareupdate --install --all > /dev/null \
    && print_success 'Update system software' \
    || print_error 'Update system software'
}

update_brew() {
  execute 'brew update | dotfiles_log' 'brew (update)'
  execute 'brew upgrade --all | dotfiles_log' 'brew (upgrade)'
  execute 'brew cleanup | dotfiles_log' 'brew (cleanup)'
}
