#!/usr/bin/env bash

ask_proxy_user() {
  ask 'Please enter your proxy username'
  proxy_user="$(get_answer)"
}

reset_proxy_user() {
  proxy_user=""
}

ask_proxy_pass() {
  ask_suppress_output 'Please enter your proxy password'
  proxy_pass="$(get_answer)"

#  printf "$(print_mask "$proxy_pass" 1 1)\n"

  set_proxy_pass_masked
  set_proxy_credentials
}

set_proxy_pass_masked() {
  masked_proxy_pass="$(print_mask "$proxy_pass" 1 1)"
}

reset_proxy_pass() {
  proxy_pass=""
  masked_proxy_pass=""
}

set_proxy_credentials() {
  if [[ -n "$proxy_user" ]]; then
    if [[ -n "$proxy_pass" ]]; then
      proxy_credentials="$proxy_user:$proxy_pass@"
      masked_proxy_credentials="$proxy_user:$masked_proxy_pass@"
    else
      proxy_credentials="$proxy_user@"
      masked_proxy_credentials="$proxy_user@"
    fi
  fi
}

reset_proxy_credentials() {
  proxy_credentials=""
  masked_proxy_credentials=""
}

ask_proxy_domain() {
  ask_for_confirmation "Are there different domains for HTTP and HTTPS proxies?"

  if answer_is_yes; then
    ask 'Please enter the HTTP proxy domain/IP'
    http_proxy_domain="$(get_answer)"

    ask 'Please enter the HTTPS proxy domain/IP'
    https_proxy_domain="$(get_answer)"

    ask 'Please enter any other proxy domain/IP'
    all_proxy_domain="$(get_answer)"
  else
    while [[ -z "$proxy_domain" || "$proxy_domain" == "" ]]; do
      ask 'Please enter the proxy domain/IP'
      proxy_domain="$(get_answer)"
    done
  fi
}

reset_proxy_domain() {
  proxy_domain=""
  http_proxy_domain=""
  https_proxy_domain=""
  all_proxy_domain=""
}

ask_proxy_port() {
  ask_for_confirmation "Are there different ports for HTTP and HTTPS proxies?"

  if answer_is_yes; then
    ask 'Please enter the HTTP proxy port'
    http_proxy_port="$(get_answer)"

    ask 'Please enter the HTTPS proxy port'
    https_proxy_port="$(get_answer)"

    ask 'Please enter any other proxy port'
    all_proxy_port="$(get_answer)"
  else
    ask 'Please enter the proxy port'
    proxy_port="$(get_answer)"
  fi

  set_proxy_url
}

reset_proxy_port() {
  proxy_port=""
  http_proxy_port=""
  https_proxy_port=""
  all_proxy_port=""
}

set_proxy_url() {
  [[ -n "$proxy_domain" ]]       && proxy_url="$proxy_domain"
  [[ -n "$http_proxy_domain" ]]  && http_proxy_url="$http_proxy_domain"
  [[ -n "$https_proxy_domain" ]] && https_proxy_url="$https_proxy_domain"
  [[ -n "$all_proxy_domain" ]]   && all_proxy_url="$all_proxy_domain"

  [[ -n "$proxy_port" ]]         && proxy_url="$proxy_url:$proxy_port"
  [[ -n "$http_proxy_port" ]]    && http_proxy_url="${http_proxy_url:-$proxy_url}:${http_proxy_port:-$proxy_port}"
  [[ -n "$https_proxy_port" ]]   && https_proxy_url="${https_proxy_url:-$proxy_url}:${https_proxy_port:-$proxy_port}"
  [[ -n "$all_proxy_port" ]]     && all_proxy_url="${all_proxy_url:-$proxy_url}:${all_proxy_port:-$proxy_port}"
}

reset_proxy_url() {
  proxy_url=""
  http_proxy_url=""
  https_proxy_url=""
  all_proxy_url=""
}

concat_proxy_settings() {
  http_proxy="http://${proxy_credentials}${http_proxy_url:-$proxy_url}"
  https_proxy="http://${proxy_credentials}${https_proxy_url:-$proxy_url}"
  all_proxy="http://${proxy_credentials}${all_proxy_url:-$proxy_url}"

  masked_http_proxy="http://${masked_proxy_credentials}${http_proxy_url:-$proxy_url}"
  masked_https_proxy="http://${masked_proxy_credentials}${https_proxy_url:-$proxy_url}"
  masked_all_proxy="http://${masked_proxy_credentials}${all_proxy_url:-$proxy_url}"
}

reset_proxy_settings() {
  http_proxy=""
  https_proxy=""
  all_proxy=""

  masked_http_proxy=""
  masked_https_proxy=""
  masked_all_proxy=""

  reset_proxy_credentials
  reset_proxy_domain
  reset_proxy_pass
  reset_proxy_port
  reset_proxy_url
  reset_proxy_user
}

confirm_proxy_settings() {
  print_subtitle "Proxy settings are:"

  printf "\n"

  printf '   http_proxy = %s \n' "$masked_http_proxy"
  printf '  https_proxy = %s \n' "$masked_https_proxy"
  printf '    all_proxy = %s \n\n' "$masked_all_proxy"

  ask_for_confirmation "Are these correct?"
}

ask_proxy_settings() {
  ask_proxy_user
  ask_proxy_pass
  ask_proxy_domain
  ask_proxy_port

  concat_proxy_settings

  confirm_proxy_settings

  if answer_is_yes; then
    return 0
  else
    reset_proxy_settings

    ask_for_confirmation "Do you want to try setting the proxy settings again?"

    if answer_is_yes; then
      ask_proxy_settings && return 0
    fi
  fi

  return 1
}

save_proxy_settings_to_apt() {
  if is_ubuntu; then
    echo "Acquire::http::Proxy \"${http_proxy}\";" | sudo tee -a "${APT_RC}" &> /dev/null
    echo "appended http proxy to ${APT_RC}" >> ~/.dotfiles.log

    echo "Acquire::https::Proxy \"${https_proxy}\";" | sudo tee -a "${APT_RC}" &> /dev/null
    echo "appended https proxy to ${APT_RC}" >> ~/.dotfiles.log

    print_success "Proxy set: ${APT_RC}"
  fi
}

save_proxy_settings_to_npm() {
  if command -v 'npm' > /dev/null; then
    npm config --global set proxy "${http_proxy}" &>> ~/.dotfiles.log
    print_result $? "NPM HTTP Proxy"

    npm config --global set https-proxy "${https_proxy}" &>> ~/.dotfiles.log
    print_result $? "NPM HTTPS Proxy"
  fi
}

save_proxy_settings_to_git() {
  if command -v 'git' > /dev/null; then
    git config --global http.proxy "${http_proxy}" &>> ~/.dotfiles.log
    print_result $? "Git HTTP Proxy"

    git config --global https.proxy "${https_proxy}" &>> ~/.dotfiles.log
    print_result $? "Git HTTPS Proxy"
  fi
}

#save_proxy_settings_to_bower() {
  # To be completed
  #if command -v 'bower' > /dev/null; then
  #
  #fi
#}

save_proxy_settings_to_gem() {
  if [[ -n "$RVM_DIR" && -d "$RVM_DIR" ]]; then
    if content_exists_in_file "${GEM_RC}" "http-proxy"; then
      remove_line_from_file "${GEM_RC}" "http-proxy:"
    fi

    append_content_to_file "${GEM_RC}" "http-proxy: ${http_proxy}"

    if content_exists_in_file "${GEM_RC}" "https-proxy"; then
      remove_line_from_file "${GEM_RC}" "https-proxy:"
    fi

    append_content_to_file "${GEM_RC}" "https-proxy: ${https_proxy}"
  fi
}

save_proxy_settings_to_bash() {
  if content_block_exists_in_file "Proxy" "${BASH_RC_LOCAL}"; then
    content_block_remove "Proxy" "${BASH_RC_LOCAL}"
  fi

  local proxy_stream="$(content_block_stream_new Proxy)"

  stream_add "${proxy_stream}" "export proxy_user=\"${proxy_user}\""
  stream_add "${proxy_stream}" "export proxy_pass=\"${proxy_pass}\""

  stream_add "${proxy_stream}" "export http_proxy=\"${http_proxy}\""
  stream_add "${proxy_stream}" "export https_proxy=\"${https_proxy}\""
  stream_add "${proxy_stream}" "export all_proxy=\"${all_proxy}\""

  stream_add "${proxy_stream}" "export saved_http_proxy=\"${http_proxy}\""
  stream_add "${proxy_stream}" "export saved_https_proxy=\"${https_proxy}\""
  stream_add "${proxy_stream}" "export saved_all_proxy=\"${all_proxy}\""

  content_block_stream_write "${proxy_stream}" "${BASH_RC_LOCAL}"
}

save_proxy_settings() {
  if [[ -n "${http_proxy}" ]]; then

    save_proxy_settings_to_bash

    ask_for_confirmation 'Do you want to use these Proxy settings for Aptitude (apt-get)?'

    if answer_is_yes; then
      save_proxy_settings_to_apt
    fi

    if command -v 'npm' > /dev/null; then
      ask_for_confirmation 'Do you want to use these Proxy settings for NPM (global)?'

      if answer_is_yes; then
        save_proxy_settings_to_npm
      fi
    fi

    if command -v 'git' > /dev/null; then
      ask_for_confirmation 'Do you want to use these Proxy settings for Git (global)?'

      if answer_is_yes; then
        save_proxy_settings_to_git
      fi
    fi

    if command -v 'gem' > /dev/null || type -t 'gem' > /dev/null; then
      ask_for_confirmation 'Do you want to use these Proxy settings for Ruby?'

      if answer_is_yes; then
        save_proxy_settings_to_gem
      fi
    fi

    # THESE LINES ARE IMPORTANT
    export http_proxy="$http_proxy"
    export https_proxy="$https_proxy"
    export all_proxy="$all_proxy"
  fi
}

parse_proxy_from_url() {
  local supplied_proxy="${1}"

  if [[ "${supplied_proxy}" =~ https?://[^:]+:[^@]+@[^:]+:[0-9]+ ]]; then
    proxy_complex="$(echo "${supplied_proxy}" | cut -d'/' -f3)"

    proxy_user="$(echo "${proxy_complex}" | cut -d':' -f1)"
    proxy_pass="$(echo "${proxy_complex}" | cut -d':' -f2 | cut -d'@' -f1)"

    set_proxy_pass_masked
    set_proxy_credentials

    proxy_domain="$(echo "${proxy_complex}" | cut -d':' -f2 | cut -d'@' -f2)"
    proxy_port="$(echo "${proxy_complex}" | cut -d':' -f3)"
  elif [[ "${supplied_proxy}" =~ https?://[^:]+:[0-9]+ ]]; then
    proxy_complex="$(echo "${supplied_proxy}" | cut -d'/' -f3)"
    proxy_domain="$(echo "${proxy_complex}" | cut -d':' -f1 | cut -d'@' -f2)"
    proxy_port="$(echo "${proxy_complex}" | cut -d':' -f2)"
  fi

  set_proxy_url

  concat_proxy_settings

  debug "\$proxy_complex             = ${proxy_complex}"
  debug "\$proxy_user                = ${proxy_user}"
  debug "\$proxy_pass                = ${proxy_pass}"
  debug "\$proxy_credentials         = ${proxy_credentials}"
  debug "\$masked_proxy_credentials  = ${masked_proxy_credentials}"
  debug "\$proxy_domain              = ${proxy_domain}"
  debug "\$proxy_port                = ${proxy_port}"
  debug "\$proxy_url                 = ${proxy_url}"
  debug "\$http_proxy                = ${http_proxy}"
  debug "\$masked_http_proxy         = ${masked_http_proxy}"
}

change_proxy() {
  ask_proxy_settings && save_proxy_settings
}

# Not sure how this is going to be used yet...
#change_npm_directory_proxy() {
#  local pwd="$(pwd)"
#  local has_set_proxy=false
#  local use_existing_proxy=false
#
#  if [[ -z "${http_proxy}" || "${http_proxy}" == "" ]]; then
#    ask_for_confirmation 'Do you want to set up new Proxy details for NPM in this directory (${pwd}) now?'
#
#    if answer_is_yes; then
#      if ask_proxy_settings; then
#        has_set_proxy=true
#      fi
#    else
#      return
#    fi
#  fi
#
#  if [[ "${has_set_proxy}" == false ]]; then
#    ask_for_confirmation 'Do you want to use existing Proxy details for this directory (${pwd})?'
#
#    if answer_is_yes; then
#      use_existing_proxy=true
#    else
#      ask_for_confirmation 'Do you want to set up new Proxy details for NPM in this directory (${pwd}) now?'
#
#      if answer_is_yes; then
#        if ask_proxy_settings; then
#          has_set_proxy=true
#        fi
#      else
#        return
#      fi
#    fi
#  fi
#
#  # TODO - Include this bit in the bash proxy watcher
#  execute "npm config set proxy ${http_proxy}" "NPM HTTP Proxy"
#  execute "npm config set https-proxy ${https_proxy}" "NPM HTTPS Proxy"
#}

proxy_on() {
  export http_proxy="$saved_http_proxy"
  export https_proxy="$saved_https_proxy"
  export all_proxy="$saved_all_proxy"

  print_success "Proxy: ON"
}

proxy_off() {
  export http_proxy=""
  export https_proxy=""
  export all_proxy=""

  print_success "Proxy: OFF"
}