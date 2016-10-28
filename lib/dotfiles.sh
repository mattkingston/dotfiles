#!/usr/bin/env bash

is_log_empty() {
  [[ "$(cat ~/.dotfiles.log)" == "" ]] \
    && return 0 \
    || return 1
}

empty_log() {
  > ~./.dotfiles.log
}

update_dotfiles() {
  ssh -T git@github.com &> /dev/null

  if [[ $? -eq 1 ]]; then
    return 1
  fi

  local pwd="$(pwd)"

  if [[ -d ~/.dotfiles ]]; then
    cd ~/.dotfiles

    if is_git_repository; then
      # Update content and remove untracked files
      git fetch --all &> /dev/null \
        && git reset --hard origin/master &> /dev/null \
        && git clean -fd  &> /dev/null

      print_result $? 'Update dotfiles'
    fi
  fi

  cd "${pwd}"
}
