#!/usr/bin/env bash

get_supported_osx_version() {
  printf '%s' '10.9'
}

is_osx() {
  [[ "$(get_os)" == 'osx' ]] \
    && return 0 \
    || return 1
}

get_supported_ubuntu_version() {
  printf '%s' '12.04'
}

is_ubuntu() {
  [[ "$(get_os)" == 'ubuntu' ]] \
    && return 0 \
    || return 1
}

get_os() {
  local os_name="$(uname -s)"
  local os=""

  if [[ "${os_name}" == "Darwin" ]]; then
    os='osx'
  elif [[ "${os_name}" == "Linux" && -e "/etc/lsb-release" ]]; then
    os='ubuntu'
  else
    os="${os_name}"
  fi

  printf "%s" "${os}"
}

is_supported_version() {
  local -a v1=(${1//./ })
  local -a v2=(${2//./ })
  local i=""

  # Fill empty positions in v1 with zeros
  for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
    v1[i]=0
  done

  for (( i=0; i<${#v1[@]}; i++ )); do
    # Fill empty positions in v2 with zeros
    if [[ -z ${v2[i]} ]]; then
      v2[i]=0
    fi

    if (( 10#${v1[i]} < 10#${v2[i]} )); then
      return 1
    fi
  done
}

is_supported_os() {
  local os_version=""
  local min_version=""

  if [[ "$(get_os)" == 'osx' ]]; then
    os_version="$(sw_vers -productVersion)"
    min_version="$(get_supported_osx_version)"
  elif [[ "$os" == 'ubuntu' ]]; then
    os_version="$(lsb_release -d | cut -f2 | cut -d' ' -f2)"
    min_version="$(get_supported_ubuntu_version)"
  fi

  is_supported_version "${os_version}" "${min_version}" \
    && return 0 \
    || return 1
}
