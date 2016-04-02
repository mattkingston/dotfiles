#!/usr/bin/env bash

if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

if type -t 'aws' > /dev/null; then
  complete -C aws_completer aws
fi
