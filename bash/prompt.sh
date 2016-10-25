#!/usr/bin/env bash

set_bash_prompt() {
  local prompt_symbol='\$'
  local bold=""
  local reset=""
  local cyan=""
  local green=""
  local orange=""
  local white=""
  local yellow=""

  if [[ -x /usr/bin/tput ]] && tput setaf 1 &> /dev/null; then
      tput sgr0 # Reset colors
      bold=$(tput bold)
      reset=$(tput sgr0)
      cyan=$(tput setaf 37)
      green=$(tput setaf 64)
      orange=$(tput setaf 166)
      white=$(tput setaf 15)
      yellow=$(tput setaf 136)
  else
      bold="\e[1m"
      reset="\e[0m"
      cyan="\e[38;5;37m"
      green="\e[38;5;64m"
      orange="\e[38;5;166m"
      white="\e[38;5;15m"
      yellow="\e[38;5;136m"
  fi

  function print_if_repo() {
    git rev-parse --is-inside-work-tree &> /dev/null || return
    printf "${1}"
  }

  function git_repo_info() {
    # check if we're in a git repo. (fast)
    git rev-parse --is-inside-work-tree &> /dev/null || return

    printf "$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
        git describe --all --exact-match HEAD 2> /dev/null || \
        git rev-parse --short HEAD 2> /dev/null || \
        printf '(unknown)')" | tr -d "\n";

    printf "$(git diff --no-ext-diff --quiet --ignore-submodules --exit-code || echo -e "*")";
  }

  PS1="\[\033]0;\w\007\]"         # Terminal title (set to the
                                  # current working directory)

  if [[ "${PROMPT_SHOW_USERNAME}" -eq "1" ]]; then
    PS1+="\[${bold}\]"
    PS1+="\[${orange}\]\u"            # Username
    PS1+="\[${white}\]@"
    PS1+="\[${yellow}\]\h"            # Host
    PS1+="\[${white}\]: "
  fi

  PS1+="\[${green}\]\w"             # Working directory
  PS1+="\[${white}\]\$(print_if_repo ' on ')\[${cyan}\]\$(git_repo_info)"
  PS1+="\[${white}\] ${prompt_symbol} \[${reset}\]"

  export PS1

  PS2='⚡ '

  export PS2
}

set_bash_prompt

unset set_bash_prompt
