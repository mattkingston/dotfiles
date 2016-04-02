#!/usr/bin/env bash

# Debug utils

debug() {
  printf '$(tput setaf 241)  [D] %s\n$(tput sgr0)' "${1}" # Print in grey
}

debug_title() {
  printf '$(tput setaf 241)\n\n  [#] ------------\n## %s\n\n$(tput sgr0)' "${1}" # Print in grey
}

debug_subtitle() {
  printf '$(tput setaf 241)  [#] %s\n\n$(tput sgr0)' "${1}" # Print in grey
}

debug_params() {
  local array=( "$@" )

  for i in "${array[@]}"; do
    if is_param_defined "$(param_to_string "$i")" "${array[@]}"; then
      debug_param_key_value "$(param_to_string "$i")" "${array[@]}"
    fi
  done
}

debug_param_key_value() {
  debug_param_key "$@"
  debug_param_value "$@"
  printf "\n"
}

debug_param_key() {
  printf '$(tput setaf 241)  %s) $(tput sgr0)' "$(array_peek "$@")" # Print in grey
}

debug_param_value() {
  printf '$(tput setaf 241)%s$(tput sgr0)' "$(get_param_value "$@")" # Print in grey
}

debug_array() {
  local array=( "$@" )
  local count=0

  until [[ "${count}" == "${#array[@]}" ]]; do
    printf "$(tput setaf 241)  ${count}) %s\n$(tput sgr0)" "${array[$count]}" # Print in grey
    let count+=1
  done
}
