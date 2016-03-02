#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Variables

declare -r -a NPM_PACKAGES=(
    'babel'
    'browserify'
    'jshint'
    'bower'
    'grunt'
    'grunt-cli'
    'gulp'
    'svgo'
    'yo'
    'karma'
    'fsmonitor'
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_npm_packages() {

    local workingDirectory="$(pwd)" \
      && cd "$(dirname $BASH_SOURCE[0])"

    # Check if `NVM_DIR` is set, and if it's not, it's because
    # `~/.bash.local` was not sourced and therefore, npm won't
    # be available (this happens when the `dotfiles` are set up
    # for the first time)

    [ -z "$NVM_DIR" ] \
      && [ -f "$HOME/.bash.local" ] \
      && source "$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `npm` is installed

    if ! cmd_exists 'npm'; then
        print_error 'npm is required, please install it!\n'
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    execute_quietly "npm config set registry http://registry.npmjs.org/" 'NPM Configure registry'

    # TODO - Include this bit in the bash proxy watcher
    if [ "$HTTP_PROXY" != "" ]; then
        execute_quietly "npm config set proxy $HTTP_PROXY" "NPM HTTP Proxy"
        execute_quietly "npm config set https-proxy $HTTPS_PROXY" "NPM HTTPS Proxy"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Ensure the most recent version of `npm` is installed

    execute_quietly 'npm install --global npm' 'npm (update)'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install the `npm` packages

    for i in ${NPM_PACKAGES[@]}; do
        execute_quietly "npm install --global $i" "$i"
    done
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_npm_packages

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_npm_packages
