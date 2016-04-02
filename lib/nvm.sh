#!/usr/bin/env bash

is_nvm_installed() {
  [[ -n "${NVM_DIR}" && -d "${NVM_DIR}" && -f "${NVM_DIR}/nvm.sh" ]] \
    && return 0 \
    || return 1
}

nvm_update() {
  if is_nvm_installed; then
    # Ensure the latest version of nvm is used
    cd "$NVM_DIR" \
      && git checkout `git describe --abbrev=0 --tags` &> /dev/null

    print_result $? 'NVM update'
  else
    print_error "NVM not installed"
  fi
}

#nvm_set_dir() {
#  local dir="$1"
#
#  if content_block_exists_in_file "NVM" "${BASH_RC_LOCAL}"; then
#    content_block_remove "NVM" "${BASH_RC_LOCAL}"
#  fi
#
#  local nvm_stream="$(content_block_stream_new 'NVM')"
#
#  stream_add "${nvm_stream}" "export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist"
#  stream_add "${nvm_stream}" "export NVM_DIR='${dir}'"
#
#  content_block_stream_write "${nvm_stream}" "${BASH_RC_LOCAL}"
#
#  # THESE LINES ARE IMPORTANT
#  export NVM_NODEJS_ORG_MIRROR="http://nodejs.org/dist"
#  export NVM_DIR="${dir}"
#}

nvm_default() {
  local version="$1"

  if is_nvm_installed; then
    nvm alias default "$version" &> /dev/null

    print_result $? "NVM set default: $version"
  else
    print_error "NVM not installed"
  fi
}
