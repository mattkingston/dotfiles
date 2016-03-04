#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Variables

declare -r -a RUBY_VERSIONS=(
    '1.9.3'
)

declare RUBY_DEFAULT='1.9.3'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_ruby_versions() {

    declare -r RVM_DIRECTORY="$HOME/.rvm"
    declare -r CONFIGS='
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ruby Version Manager

export RVM_DIR="'$RVM_DIRECTORY'"

export rvm_path=$RVM_DIR

[ -f "$RVM_DIR/scripts/completion" ] \
  && source $RVM_DIR/scripts/completion

[ -s "$RVM_DIR/scripts/rvm" ] \
  && source $RVM_DIR/scripts/rvm
' # END declare=CONFIGS

    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `Curl` is installed

    if ! cmd_exists 'curl'; then
        print_error 'Curl is required, please install it!'
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install `rvm` and add the necessary configs to `~/.bash.local`

    if [ ! -d "$RVM_DIRECTORY" ]; then
        # Import RVM keys first
        curl -sSL https://rvm.io/mpapis.asc | gpg --import - > /dev/null 2>&1

        curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles > /dev/null 2>&1

        print_result $? 'rvm'

        if [ $? -eq 0 ]; then
            [ -f "$HOME/.bash.local" ] \
              && append_to_file_once "$HOME/.bash.local" "$CONFIGS" \
              && source "$HOME/.bash.local"

            print_result $? 'rvm (update ~/.bash.local)'
        fi

    fi

    # TODO - Include this bit in the bash proxy watcher
    if [ "$HTTP_PROXY" != '' ]; then
        append_to_file_once "$HOME/.gemrc" "http-proxy: $HTTP_PROXY"
        append_to_file_once "$HOME/.gemrc" "https-proxy: $HTTPS_PROXY"

        print_in_white "\n    Proxy set: $HOME/.gemrc.\n"
    fi

    if [ -d "$RVM_DIRECTORY" ]; then

        [ -s "$RVM_DIRECTORY/scripts/rvm" ] \
          && source $RVM_DIRECTORY/scripts/rvm

        # Install ruby versions
        for i in ${RUBY_VERSIONS[@]}; do
            execute "rvm --quiet-curl --install $i" "rvm (install: $i)"
        done

        execute_quietly "rvm use --default $RUBY_DEFAULT" "rvm (set default: $RUBY_DEFAULT)"

        execute_quietly "rvm cleanup all" "rvm (cleanup)"

        if [[ "$(get_os)" == 'osx' ]]; then
            execute_quietly "rvm osx-ssl-certs update all" "Update OS X SSL certs"
        fi

    fi

    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_ruby_versions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_ruby_versions
