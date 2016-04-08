#!/usr/bin/env bash

get_color() {
  local black=""
  local blue=""
  local bold=""
  local cyan=""
  local green=""
  local orange=""
  local purple=""
  local red=""
  local reset=""
  local white=""
  local yellow=""
  local grey=""

  if [[ -x /usr/bin/tput ]] && tput setaf 1 &> /dev/null; then
      tput sgr0 # Reset colors
      bold=$(tput bold)
      reset=$(tput sgr0)
      black=$(tput setaf 0)
      blue=$(tput setaf 111)
      cyan=$(tput setaf 37)
      green=$(tput setaf 64)
      orange=$(tput setaf 166)
      purple=$(tput setaf 126)
      red=$(tput setaf 124)
      white=$(tput setaf 15)
      yellow=$(tput setaf 136)
      grey=$(tput setaf 241)
  else
      bold="\e[1m"
      reset="\e[0m"
      black="\e[38;5;0m"
      blue="\e[38;5;111m"
      cyan="\e[38;5;37m"
      green="\e[38;5;64m"
      orange="\e[38;5;166m"
      purple="\e[38;5;126m"
      red="\e[38;5;124m"
      white="\e[38;5;15m"
      yellow="\e[38;5;136m"
      grey="\e[38;5;241m"
  fi

  if [[ "$1" == "none" ]]; then
    printf "$reset"
  else
    [[ -n "${!1}" && "${!1}" != "" ]] && printf '%s' "${!1}"
  fi
}

print_bold() {
  printf "$(get_color 'bold')"
}

print_reset() {
  printf "$(get_color 'none')"
}

print_color() {
  printf "$(get_color "${1}")"
}

print_tabs_prefix() {
  printf '      '
}

print_symbol_prefix() {
  printf '  [%s] ' "${1}"
}

print_title() {
  printf "\n"
  get_color 'purple'
  print_tabs_prefix
  printf '%s\n' "${1}"
  printf '%s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_subtitle() {
  printf "\n"
  print_bold
  get_color 'white'
  print_tabs_prefix
  printf '%s\n' "${1}"
  printf '%s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_info() {
  get_color 'white'
  print_tabs_prefix
  printf '%s\n' "${1}"
  printf '%s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_subtle() {
  get_color 'grey'
  print_tabs_prefix
  printf '%s\n' "${1}"
  printf '%s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_question() {
  printf "\n"
  get_color 'blue'
  print_symbol_prefix "?"
  printf '%s ' "${1}"
  printf 'QUESTION: %s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_success() {
  get_color 'green'
  print_symbol_prefix "✔"
  printf '%s\n' "${1}"
  printf 'SUCCESS: %s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_notice() {
  get_color 'yellow'
  print_symbol_prefix "!"
  printf '%s\n' "${1}"
  printf 'NOTICE: %s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_warning() {
  get_color 'orange'
  print_symbol_prefix "!"
  printf '%s\n' "${1}"
  printf 'WARNING: %s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_error() {
  get_color 'red'
  print_symbol_prefix "✖"
  printf '%s\n' "${1}"
  printf 'ERROR: %s\n' "${1}" >> ~/.dotfiles.log
  print_reset
}

print_result() {
  [[ "$1" -eq 0 ]] \
    && print_success "$2" \
    || print_error "${3:-$2}";

  return $1
}

print_mask() {
  local str="$1"
  local str_len="${#str}"
  local -i length_to_mask=0
  local -i visible_start=$2
  local -i visible_end=$3

  if [[ "$str_len" -lt 1 || "$str_len" -lt "$(( $visible_end + $visible_end ))" ]]; then
    return
  fi

  if [[ "$visible_end" -gt 0 && "$visible_start" -gt 0 ]]; then
    length_to_mask="$(( $str_len - $visible_start - $visible_end ))"
  elif [[ "$visible_end" -gt 0 ]]; then
    length_to_mask="$(( $str_len - $visible_end ))"
  fi

  if [[ "$visible_start" -gt 0 && "$visible_end" -gt 0 ]]; then

    printf '%s' "${str:0:$visible_start}"
    printf '%s' "$(printf '%s' "${str:$visible_start:$length_to_mask}" | tr [:print:] \*)"
    printf '%s' "${str: -$visible_end}"

  elif [[ "$visible_start" -gt 0 ]]; then

    printf '%s' "${str:0:$visible_start}"
    printf '%s' "$(printf '%s' "${str:$visible_start}" | tr [:print:] \*)"

  elif [[ "$length_to_mask" -gt 0 && "$visible_end" -gt 0 ]]; then

    printf '%s' "$(printf '%s' "${str:0:$length_to_mask}" | tr [:print:] \*)"
    printf '%s' "${str: -$visible_end}"

  else
    printf '%s' "$(printf "$1" | tr [:print:] \*)"
  fi
}
