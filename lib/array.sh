#!/usr/bin/env bash

# Array utils

array_peek() {
  array_get_index 0 "$@"
}

array_peek_end() {
  array_get_index -1 "$@"
}

array_get_index() {
  local -i index="${1}" && shift
  local -a array=( "$@" )
  local -i array_length="${#array[@]}"

  if [[ "$index" -lt 0 ]]; then
    index="$((array_length - $(( $(printf '%d' "$index" | sed 's/^-//') ))))"
  fi

  printf '%s' "${array[$index]}"
}

array_get_index_from_key() {
  local key="$(array_peek "$@")" && shift
  local i=0
  local -a array=( "$@" )
  local array_length="${#array[@]}"

  if [[ "${array_length}" -gt 0 ]]; then
    until [[ "${i}" == "$(( ${array_length} - 1 ))" ]]; do
      [[ "${array[$i]}" == "${key}" ]] \
        && printf '%s' "$i" \
        && break

      let i+=1
    done
  fi
}