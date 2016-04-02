#!/usr/bin/env bash

#gem_set_gemrc() {
#  local location="$1"
#
#  if content_block_exists_in_file "GEM_RC" "${BASH_RC_LOCAL}"; then
#    content_block_remove "GEM_RC" "${BASH_RC_LOCAL}"
#  fi
#
#  local gem_stream="$(content_block_stream_new 'GEM_RC')"
#
#  stream_add "${gem_stream}" "export GEM_RC='${location}'"
#
#  content_block_stream_write "${gem_stream}" "${BASH_RC_LOCAL}"
#
#  # THESE LINES ARE IMPORTANT
#  export GEM_RC="${location}"
#}