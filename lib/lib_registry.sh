#!/usr/bin/env bash

# Dotfiles utils

#declare -a DOTFILES_LIB_REGISTER=()
#
#lib_register_count() {
#  local lib="$1"
#  local i=""
#  local count=0
#
#  for i in ${!DOTFILES_LIB_REGISTER[*]}; do
#    if [[ ${DOTFILES_LIB_REGISTER[$i]} == "${lib}" ]]; then
#      let count+=1
#    fi
#  done
#
#  printf '%s' "$count"
#}
#
#lib_in_register() {
#  local lib="$1"
#  local count="$(lib_register_count"${lib}")"
#
#  [[ "$count" != 0 ]] \
#    && return 0 \
#    || return 1
#}
#
#lib_register_add() {
#  DOTFILES_LIB_REGISTER+=("${1}")
#}
#
#lib_register_remove() {
#  local lib="$1"
#
#  for i in ${!DOTFILES_LIB_REGISTER[*]}; do
#    if [[ ${DOTFILES_LIB_REGISTER[$i]} == "${lib}" ]]; then
#      unset DOTFILES_LIB_REGISTER["$i"]
#      break
#    fi
#  done
#}
#
#lib() {
#  [[ "$1" == "dotfiles" ]] && return
#
#  if [[ -e "$(printf "${DOTFILES_DIR}/lib/%s.sh" "$1")" ]]; then
#    if ! lib_in_register "$1"; then
#      lib_register_add "$1"
#      . "$(printf "${DOTFILES_DIR}/lib/%s.sh" "${1}")"
#    else
#      lib_register_add "$1"
#    fi
#  fi
#}
#
#lib_cleanup() {
#  local lib="$1"
#
#  if lib_in_register "${lib}"; then
#    if [[ "$(lib_register_count "${lib}")" == "1" ]]; then
#      type -t "${lib//\//_}_lib_cleanup" &> /dev/null \
#        && lib_register_remove "$lib" \
#        && eval "${lib//\//_}_lib_cleanup"
#    elif [[ "$(lib_register_count "${lib}")" -gt "1" ]]; then
#      lib_register_remove "$lib"
#    fi
#  fi
#}
