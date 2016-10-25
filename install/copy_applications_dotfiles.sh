#!/usr/bin/env bash

copy_dotfiles() {
  local pwd="$(pwd)"
  local backup_suffix="${1}"
  local backup_dir=""

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  local dotfiles=(
    'gemrc'
    'gvimrc'
    'npmrc'
    'vimrc'
    'tmux.conf'
  )

  if [[ "$backup_suffix" != "" ]]; then
    backup_dir=~/.dotfiles.backup-"${backup_suffix}"
  fi

  for i in "${dotfiles[@]}"; do
    # can we check for gem here too? before we installed though.. maybe not? or capture intent?

    if [[ "${i}" == "vimrc" && ! -e ~/.dotfiles/.vim_installed ]]; then
      echo "Skipped vimrc because VIM was not installed using setup" >> ~/.dotfiles.log
      continue
    fi

    if [[ "${i}" == "gvimrc" && ! -e ~/.dotfiles/.vim_installed ]]; then
      echo "Skipped gvimrc because VIM was not installed using setup" >> ~/.dotfiles.log
      continue
    fi

    if [[ "${i}" == "tmux.conf" && ! -e ~/.dotfiles/.tmux_installed ]]; then
      echo "Skipped tmux.conf because Tmux was not installed using setup" >> ~/.dotfiles.log
      continue
    fi

    if [[ -e ~/."${i}" && -n "${backup_dir}" ]]; then
      if [[ ! -d "${backup_dir}" ]]; then
        mkdir -v "${backup_dir}" &>> ~/.dotfiles.log
      fi

      mv -v ~/."${i}" "${backup_dir}/dotfiles" &>> ~/.dotfiles.log
    fi

    cp -v ../dotfiles/"${i}" ~/."${i}" &>> ~/.dotfiles.log
  done

  cd "${pwd}"
}

copy_dotfiles "${1}"

unset copy_dotfiles
