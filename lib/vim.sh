#!/usr/bin/env bash

is_vim_installed() {
  if command -v 'git' > /dev/null; then
    if [[ -n "${VIM_DIR}" && -d "${VIM_DIR}" ]]; then
      return 0
    fi
  fi

  return 1
}

vim_reinstall_plugins() {
  if ! command -v "git" > /dev/null; then
    print_error 'Git is required to (re)install Vim'
    exit 1
  fi

  rm -rf "${VIM_DIR}/plugins/Vundle.vim" &> /dev/null \
    && git clone -q "https://github.com/gmarik/Vundle.vim.git" "${VIM_DIR}/plugins/Vundle.vim" \
    && printf "\n" | vim +PluginInstall +qall

  print_result $? 'Install Vim plugins'
}

vim_update_plugins() {
  if ! command -v 'git' > /dev/null; then
    print_error 'Git is required to update Vim plugins'
    exit 1
  fi

  local pwd="$(pwd)"

  if is_vim_installed; then
    cd "${VIM_DIR}" && git -q fetch --tags

    local tag="$(git describe --tags $(git rev-list --tags --max-count=1))"

    if [[ "$tag" != "" ]]; then
      git -q checkout "${tag}" \
        && printf "\n" | vim +PluginInstall +qall 2> /dev/null

      print_result $? 'Install vim plugins'
    fi
  fi
}

#vim_set_vimrc() {
#  local location="$1"
#
#  if content_block_exists_in_file "VIM_RC" "${BASH_RC_LOCAL}"; then
#    content_block_remove "VIM_RC" "${BASH_RC_LOCAL}"
#  fi
#
#  local vim_stream="$(content_block_stream_new 'VIM_RC')"
#
#  stream_add "${vim_stream}" "export VIMINIT=\"source $MYVIMRC\""
#  stream_add "${vim_stream}" "export MYVIMRC=${location}"
#
#  content_block_stream_write "${vim_stream}" "${BASH_RC_LOCAL}"
#
#  # THESE LINES ARE IMPORTANT
#  export MYVIMRC="${location}"
#}
