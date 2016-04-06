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
    if [[ "${i}" == "vimrc" && ! -e ~/.dotfiles/.vim_installed ]]; then
      echo "Skipped vimrc because VIM was not installed using setup" | dotfiles_log
      continue
    fi

    if [[ "${i}" == "gvimrc" && ! -e ~/.dotfiles/.vim_installed ]]; then
      echo "Skipped gvimrc because VIM was not installed using setup" | dotfiles_log
      continue
    fi

    if [[ "${i}" == "tmux.conf" && ! -e ~/.dotfiles/.tmux_installed ]]; then
      echo "Skipped tmux.conf because Tmux was not installed using setup" | dotfiles_log
      continue
    fi

    if [[ -e ~/."${i}" && -n "${backup_dir}" ]]; then
      if [[ ! -d "${backup_dir}" ]]; then
        mkdir -v "${backup_dir}" | dotfiles_log
      fi

      mv -v ~/."${i}" "${backup_dir}/dotfiles" | dotfiles_log
    fi

    cp -v ./dotfiles/"${i}" ~/."${i}" | dotfiles_log
  done

  cd "${pwd}"
}

copy_dotfiles "${1}"

unset copy_dotfiles
