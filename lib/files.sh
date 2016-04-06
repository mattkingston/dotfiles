#!/usr/bin/env bash

get_absolute_source() {
  local file="$1"
  local true_source=""

  if [[ -L "$file" ]]; then
    if [[ "$(get_os)" == "osx" ]]; then
      true_source="$(readlink "${file}")"
    else
      true_source="$(readlink -f "${file}")"
    fi
  else
     true_source="$(dirname "${file}")"
  fi

  if [[ -d "${true_source}" ]]; then
    true_source="$(cd "${true_source}"; pwd)"
  elif [[ -f "${true_source}" ]]; then
    if [[ "${true_source}" == */* ]]; then
      true_source="$(cd "${true_source%/*}"; pwd)"
    else
      true_source="$(pwd)"
    fi
  fi

  printf '%s' "${true_source}"
}

make_dir() {
  if [[ -n "${1}" ]]; then
    if [[ -e "${1}" ]]; then
      if [[ ! -d "${1}" ]]; then
        print_error "${1} - a file with the same name already exists!"
      else
        print_success "${1}"
      fi
    else
      mkdir -p "${1}" &>> ~/.dotfiles.log
      print_result $? "${1}"
    fi
  fi
}

truncate() {
  cat /dev/null > "${1}"
  echo "truncated: $1"

  print_result $? "Truncate: ${1}"
}

append_content_to_file() {
  local file="${1}"
  local content="${2}"

  printf "${content}\n" >> "${file}"
  echo "appended content to $file" | dotfiles_log

  print_result $? "${3:-Append: ${file}}"
}

insert_content_to_file_at_line() {
  local file="${1}"
  local content="${2}"
  local line="${3}"

  sed -i.bak "${line}i\n${content}" "${file}" &>> ~/.dotfiles.log

  print_result $? "${3:-Append: ${file}:${line}}"
}

remove_content_from_file() {
  local file="${1}"
  local content="${2}"

  sed -i.bak "s|${content}||" "${file}" &>> ~/.dotfiles.log
    rm -v "${file}.bak" &>> ~/.dotfiles.log

  print_result $? "Trimmed: ${file}"
}

remove_line_from_file() {
  local file="${1}"
  local line=""
  local content=""

  if [[ "$2" =~ ^-?[0-9]+$ ]]; then
    line="$2"

    sed -i.bak "${line}d" "${file}" &>> ~/.dotfiles.log
      rm -v "${file}.bak" &>> ~/.dotfiles.log
  else
    content="$2"

    sed -i.bak "/${content}/d" "${file}" &>> ~/.dotfiles.log
      rm -v "${file}.bak" &>> ~/.dotfiles.log
  fi

  print_result $? "Trimmed: ${file}"
}

content_exists_in_file() {
  local file="${1}"
  local search="${2}"
  local exists=1 # Defaults to 1

  if command -v 'pcregrep' > /dev/null; then
    if pcregrep -qM "${search}" "${file}" &> /dev/null; then
      exists=0 # Success is 0
    fi
  else
    if grep -q "${search}" "${file}" &> /dev/null; then
      exists=0 # Success is 0
    fi
  fi

  [[ "$exists" -eq 0 ]] \
    && return 0 \
    || return 1
}

# can_extract
# checks for tar binary
#
# usage example
# <code>
# if ! can_extract; then
#   printf '%s' "tar binary required"
# fi
# </code>

can_extract() {
  [[ "$(command -v 'tar')" -eq 0 ]] \
    && return 0 \
    || return 1
}

# untar
# extracts the contents of a tarball into a directory
#
# usage example
# <code>
# untar <tarball> <output-to-directory> \
#   || printf '%s' "Error extracting tarball"
# </code>

untar() {
  local tar_file="${1}"
  local out_dir="${2}"

  if [[ ! -d "${out_dir}" ]]; then
    mkdir "${out_dir}" &>> ~/.dotfiles.log
  fi

  tar -zxvf "${tar_file}" --strip-components 1 -C "${out_dir}" &>> ~/.dotfiles.log \
    || return 1
}

stream_new() {
  local stream_out_file="$(mktemp /tmp/XXXXXX)"
  printf '%s' "${stream_out_file}"
}

stream_add() {
  local stream="${1}"
  local content="${2}"

  printf '%s\n' "${content}" >> "${stream}"
}

stream_write() {
  local stream="${1}"
  local out_file="${2}"

  mv -i "${stream}" "${out_file}" &> /dev/null
  print_result $? "Created: ${out_file}"
}

content_block_stream_new() {
  local name="${1}"
  local stream="$(mktemp /tmp/${name}_XXXXXX)"
  printf '%s\n' "# Start ${name}" >> "${stream}"
  printf '%s\n' "# - - - - - - - - - - - - - - - - - " >> "${stream}"
  printf '%s' "${stream}"
}

content_block_stream_write() {
  local name="$(expr "${1##*/}" : '\([a-zA-Z0-9_-]*\)_')"
  local stream="${1}"
  local out_file="${2}"

  printf '%s\n' "# End ${name}" >> "${stream}" # Add block end indicator on last line

  if [[ ! -e "${out_file}" ]]; then
    mv -i "${stream}" "${out_file}" &> /dev/null
    print_result $? "Created: '${name}' block : ${out_file}"
  else
    echo "$(cat "${stream}")" >> "${out_file}" \
      && rm -v "${stream}" &>> ~/.dotfiles.log

    print_result $? "Append: '${name}' block : ${out_file}"
  fi
}

content_block_remove() {
  local name="${1}"
  local file="${2}"
  local start_line="$(grep -n "# Start ${name}" "${file}" | cut -d : -f 1)"
  local end_line="$(grep -n "# End ${name}" "${file}" | cut -d : -f 1)"

  sed -i '' "${start_line},${end_line}d" "${file}" &>> ~/.dotfiles.log

  print_result $? "Removed: '${name}' block"
}

content_block_exists_in_file() {
  local name="${1}"
  local file="${2}"

  grep -q "# Start ${name}" "${file}" \
    && return 0 \
    || return 1
}
