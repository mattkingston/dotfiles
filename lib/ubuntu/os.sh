#!/usr/bin/env bash

apt_key_add() {
  wget -qO - "$1" | sudo apt-key add - &> /dev/null
}

apt_key_add_all() {
  awk -F/ '/^[[:blank:]]*deb[[:blank:]]+http:\/\/ppa\.launchpad\.net\// {print "https://launchpad.net/~"${4}"/+archive"}' \
    /etc/apt/sources.list{,.d/*.list} | \
    xargs -- wget -q -O- | \
    awk -F\" '/http:\/\/keyserver\.ubuntu\.com:11371/ {sub(/amp;op=index/,"op=get");print ${2}}' | \
    xargs -- wget -q -O- | sudo apt-key add - &> /dev/null
}

apt_key_accept() {
  local keyserver="$1"
  local keys="$2"

  sudo -E apt-key adv --keyserver "${keyserver}" --recv-keys "${keys}" | dotfiles_log
  print_result "$PIPESTATUS[0]" "Accept keys ${2}"
}

apt_ppa_add() {
  sudo -E add-apt-repository -y ppa:"${1}" | dotfiles_log
  print_result "$PIPESTATUS[0]" "Add ppa ${1}"
}

apt_source_add() {
  printf 'deb %s' "${1}" | sudo tee -a '/etc/apt/sources.list.d/${2}' &> /dev/null
  print_result "$PIPESTATUS[0]" "${3:-$2}"
}

apt_install() {
  local package="${2}"
  local package_name="${1}"

  if ! command -v "${package}" && ! type -t "${package}"; then
    sudo -E apt-get install --allow-unauthenticated -y "${package}" | dotfiles_log
    print_result "$PIPESTATUS[0]" "${package_name}"
  else
    print_success "${package_name}"
  fi
}

update_ubuntu() {
  execute 'sudo -E apt-get update -y | dotfiles_log' 'Update'
  execute 'sudo -E apt-get upgrade -y | dotfiles_log' 'Upgrade'
}

apt_set_aptrc() {
  local location="$1"

  if content_block_exists_in_file "APT_RC" "${BASH_RC_LOCAL}"; then
    content_block_remove "APT_RC" "${BASH_RC_LOCAL}"
  fi

  local apt_stream="$(content_block_stream_new APT_RC)"

  stream_add "${apt_stream}" "export APT_RC='${location}'"

  content_block_stream_write "${apt_stream}" "${BASH_RC_LOCAL}"

  # THESE LINES ARE IMPORTANT
  export APT_RC="${location}"
}
