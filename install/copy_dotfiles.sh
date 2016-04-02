#!/usr/bin/env bash

copy_dotfiles() {
  local pwd="$(pwd)"
  local backup_suffix="${1}"
  local backup_dir=""

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local dotfiles=(
    'bash_profile'
    'curlrc'
    'gemrc'
    'gitconfig'
    'gitattributes'
    'gitignore'
    'gvimrc'
    'inputrc'
    'ls_colors'
    'npmrc'
    'vimrc'
    'tmux.conf'
  )

  if [[ "$backup_suffix" != "" ]]; then
    backup_dir=~/.dotfiles.backup-"${backup_suffix}"
  fi

  for i in "${dotfiles[@]}"; do
    if [[ -e ~/."${i}" && -n "${backup_dir}" ]]; then
      if [[ ! -d "${backup_dir}" ]]; then
        mkdir "${backup_dir}"
      fi

      mv ~/."${i}" "${backup_dir}/dotfiles"
    fi

    cp ./dotfiles/"${i}" ~/."${i}"
  done

  cd "${pwd}"
}

copy_dotfiles "${1}"

unset copy_dotfiles