#!/usr/bin/env bash

#dircolors_set_dircolorsrc() {
#  local location="$1"
#
#  if content_block_exists_in_file "DIR_COLORS" "${BASH_RC_LOCAL}"; then
#    content_block_remove "DIR_COLORS" "${BASH_RC_LOCAL}"
#  fi
#
#  local dircolor_stream="$(content_block_stream_new 'DIR_COLORS')"
#
#  stream_add "${dircolor_stream}" "export DIR_COLORS='${location}'"
#
#  content_block_stream_write "${dircolor_stream}" "${BASH_RC_LOCAL}"
#
#  # THESE LINES ARE IMPORTANT
#  export DIR_COLORS="${location}"
#}
