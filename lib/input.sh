#!/usr/bin/env bash

is_yes() {
  [[ "${1}" =~ ^[Yy]es$ || "$1" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

is_no() {
  [[ "${1}" =~ ^[Nn]o?$ ]] \
    && return 0 \
    || return 1
}

ask() {
  print_question "$1"
  read
  printf '%s\n' "$REPLY" >> ~/.dotfiles.log
}

ask_environment() {
  print_question "$1"
  read -e
  printf "\n"
  printf '%s\n' "$REPLY" >> ~/.dotfiles.log
}

ask_suppress_output() {
  print_question "$1"
  read -s
  printf "\n"
  printf '%s\n' "<HIDDEN>" >> ~/.dotfiles.log
}

ask_for_confirmation() {
  print_question "$1"

  while read -r -s -n 1; do
    # if the answer is null or "y" or "n" (not case sensitive)
    # we can accept the answer. All other letters are ignored
    if [[ -z "$REPLY" ]] || ([[ -n "$REPLY" ]] && (is_yes "$REPLY" || is_no "$REPLY")); then
      printf '%s\n' "$REPLY"
      printf '%s\n' "$REPLY" >> ~/.dotfiles.log
      break
    fi
  done
}

answer_is_null() {
  [[ -z "$REPLY" ]] \
    && return 0 \
    || return 1
}

answer_is_yes() {
  is_yes "$REPLY" \
    && return 0 \
    || return 1
}

get_answer() {
  printf "$REPLY"
}
