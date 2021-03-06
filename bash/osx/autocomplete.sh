#!/usr/bin/env bash

if [[ "$(bash --version)" =~ "version 4.3" ]]; then
  if [[ -f "$(brew --prefix)"/share/bash-completion/bash_completion ]]; then
    # Use `bash-completion` 2.x
    source "$(brew --prefix)"/share/bash-completion/bash_completion

    # Make bash complete the `g` alias, just like it does `git`
    complete -o default -o nospace -F _git g
  fi
fi

# AWS Cli completion

if type -t 'aws' > /dev/null; then
  complete -C aws_completer aws
fi