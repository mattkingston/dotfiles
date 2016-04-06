#!/usr/bin/env bash

npm_update() {
  if command -v 'npm' > /dev/null; then
    echo "Attempting npm update. Please wait" | dotfiles_log
    npm install -g npm &>> ~/.dotfiles.log
    print_result $? 'NPM update'

    echo "Attempting npm upgrade npm packages. Please wait" | dotfiles_log
    npm update -g &>> ~/.dotfiles.log
    print_result $? 'NPM upgrade all'
  fi
}

npm_config_registry() {
  if command -v 'npm' > /dev/null; then
    npm config set registry "http://registry.npmjs.org/" &>> ~/.dotfiles.log
    print_result $? 'NPM Configure registry'
  fi
}

npm_set_npmrc() {
  local location="$1"

  if content_block_exists_in_file "NPM_RC" "${BASH_RC_LOCAL}"; then
    content_block_remove "NPM_RC" "${BASH_RC_LOCAL}"
  fi

  local npm_stream="$(content_block_stream_new NPM_RC)"

  stream_add "${npm_stream}" "export NPM_RC='${location}'"

  content_block_stream_write "${npm_stream}" "${BASH_RC_LOCAL}"

  # THESE LINES ARE IMPORTANT
  export NPM_RC="${location}"
}