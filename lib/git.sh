#!/usr/bin/env bash

is_git_repository() {
  # Check if the current directory is in a Git repository
  [[ "$(git rev-parse &>/dev/null; printf $?)" -ne 0 ]] && return 1

  # Check if in `.git/` directory (some of the following
  # checks don't make sense/won't work in the `.git` directory)
  [[ "$(git rev-parse --is-inside-git-dir)" == "true" ]] && return 1

  return 0
}

get_git_dirty_suffix() {
  local tmp=''

  # Check for uncommitted changes in the index
  if ! $(git diff --quiet --ignore-submodules --cached); then
    tmp="$tmp+";
  fi

  # Check for unstaged changes
  if ! $(git diff-files --quiet --ignore-submodules --); then
    tmp="$tmp*";
  fi

  # Check for untracked files
  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    tmp="$tmp?";
  fi

  # Check for stashed files
  if $(git rev-parse --verify refs/stash &>/dev/null); then
    tmp="$tmp\$";
  fi

  [ -n "$tmp" ] && tmp=" [$tmp]"

  printf '%s' "${tmp}"
}

get_git_branch_name() {
  printf '%s' "$(git rev-parse --abbrev-ref HEAD 2> /dev/null \
    || git rev-parse --short HEAD 2> /dev/null \
    || printf " (unknown)" | tr -d "\n" )"
}

get_git_repository_details() {
  is_git_repository \
    && printf "$(print_color 'white') on $(print_color 'cyan')%s" "$(get_git_branch_name)$(get_git_dirty_suffix)"
}

git_status() {
  if ! is_git_repository; then
    printf '%s\t-\t\%s' "$(print_color 'grey' "$(pwd)")" "Not a git repository"
  else
    printf '%s on %s' "$(print_color 'white' "$(pwd)")" "$(print_color 'cyan' "$(get_git_repository_details)")"
  fi
}

git_status_all() {
  local longest_dir_name=0;

  for dir_name in *; do
    [[ "${#dir_name}" -gt "${longest_dir_name}" ]] \
      && longest_dir_name="${#dir_name}";
  done;

  printf '\n%s%${longest_dir_name}s%s' \
    "$(print_color 'grey' "DIR")" " " \
    "$(print_color 'grey' "BRANCH (* indicates dirty)")"

  find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(cd "{}" && git_status)' \; | column -ts $'\t' && printf "\n"
}
