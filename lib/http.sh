#!/usr/bin/env bash

# can_download
# checks for curl or wget binaries
#
# usage example
# <code>
# if ! can_download; then
#   prinf '%s' "curl or wget binaries required" && die
# fi
# </code>

can_download() {
  command -v 'curl' > /dev/null || command -v 'wget' > /dev/null \
    && return 0 \
    || return 1
}

# download
# downloads using curl or wget binaries
#
# usage example
# <code>
# download <url> <save-to-file> \
#   || printf '%s' "Unable to download dotfiles" \
#   && printf '%s' "Please make sure the path to the resource is correct and the file is accessible"
# </code>

download() {
  local url="${1}"
  local out_file="${2}"

  if command -v 'curl' > /dev/null; then
    curl -Lko ${out_file} "${url}" &>> ~/.dotfiles.log
  elif command -v 'wget' > /dev/null; then
    wget --no-check-certificate -O ${out_file} "${url}" &>> ~/.dotfiles.log
  else
    return 1
  fi

  grep -q 'Not found' ${out_file} \
    && return 1
}
