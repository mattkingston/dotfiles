#!/usr/bin/env bash

is_rvm_installed() {
  local installed=0

  if is_callable "rvm"; then
    if [[ -n "${RVM_DIR}" && -d "${RVM_DIR}" ]]; then
      installed=1
    fi
  fi
}

rvm_update() {
  if is_rvm_installed; then
    execute "rvm get stable | dotfiles_log" "Update RVM"
  else
    print_error "RVM not installed"
  fi
}

#rvm_set_dir() {
#  local dir="$1"
#
#  if content_block_exists_in_file "RVM" "${BASH_RC_LOCAL}"; then
#    content_block_remove "RVM" "${BASH_RC_LOCAL}"
#  fi
#
#  local rvm_stream="$(content_block_stream_new 'RVM')"
#
#  stream_add "${rvm_stream}" "export RVM_DIR='${dir}'"
#
#  content_block_stream_write "${rvm_stream}" "${BASH_RC_LOCAL}"
#
#  # THIS LINE IS IMPORTANT
#  export RVM_DIR="${dir}"
#}

rvm_default() {
  local default="$1"

  if is_rvm_installed; then
    execute "rvm use --default ${default} | dotfiles_log" "RVM set default: ${default}"
  else
    print_error "RVM not installed"
  fi
}
