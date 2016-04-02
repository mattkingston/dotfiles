#!/usr/bin/env bash

#readline_set_inputrc() {
#  local location="$1"
#
#  if content_block_exists_in_file "INPUT_RC" "${BASH_RC_LOCAL}"; then
#    content_block_remove "INPUT_RC" "${BASH_RC_LOCAL}"
#  fi
#
#  local readline_stream="$(content_block_stream_new 'INPUT_RC')"
#
#  stream_add "${readline_stream}" "export INPUTRC=${location}"
#
#  content_block_stream_write "${readline_stream}" "${BASH_RC_LOCAL}"
#
#  # THESE LINES ARE IMPORTANT
#  export INPUTRC="${location}"
#}
