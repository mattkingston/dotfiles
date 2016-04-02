#!/usr/bin/env bash

# Param utils
#   Params are simply paired arrays;
#   ie. if an argument is prefixed with '--' the next argument is the value
#   eg. `get_param_value one --one two --three four;
#

get_param_prefix() {
  printf '%s' "--"
}

get_param_value() {
  local key="$(array_peek "$@")" && shift
  local -a array=( "$@" )
  local key_index="$(array_get_index_from_key "--${key}" "${array[@]}")"
  local value="$(array_get_index "$(( $(printf '%d' "$key_index") + 1 ))" "${array[@]}")"

  ! [[ "$value" =~ ^$(get_param_prefix) ]] \
    && printf '%s' "$value"
}

is_param_defined() {
  local key="$(array_peek "$@")" && shift
  local -a array=( "$@" )
  local key_index="$(array_get_index_from_key "--${key}" "${array[@]}")"

  [[ "$key_index" != "" ]] \
    && return 0 \
    || return 1
}

param_to_string() {
  printf '%s' "$(printf '%s' "$1" | sed s/$(get_param_prefix)//)"
}

param_from_string() {
  printf '%s' "$(printf '%s' "$1" | sed s/^/$(get_param_prefix)/)"
}

