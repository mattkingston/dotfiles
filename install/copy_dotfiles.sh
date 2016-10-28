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
    'gitconfig'
    'gitattributes'
    'gitignore'
    'inputrc'
    'ls_colors'
  )

  if [[ "$backup_suffix" != "" ]]; then
    backup_dir=~/.dotfiles.backup-"${backup_suffix}"
  fi

  for i in "${dotfiles[@]}"; do
    if [[ -e ~/."${i}" && -n "${backup_dir}" ]]; then
      if [[ ! -d "${backup_dir}" ]]; then
        mkdir -v "${backup_dir}" 1>> ~/.dotfiles.log
      fi

      mv -v ~/."${i}" "${backup_dir}/dotfiles" 1>> ~/.dotfiles.log
    fi

    cp -v ../dotfiles/"${i}" ~/."${i}" 1>> ~/.dotfiles.log
  done

  cd "${pwd}"
}

copy_dotfiles "${1}"

unset copy_dotfiles
