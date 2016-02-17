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
        && cd "$(dirname $BASH_SOURCE)"

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

        if [ ! -f "$HOME/.bash.local" ]; then
            echo "" > "$HOME/.bash.local"
        fi

        if [ $? -eq 0 ]; then
            printf "%s" "$CONFIGS" >> "$HOME/.bash.local" \
                && source "$HOME/.bash.local"

            print_result $? 'rvm (update ~/.bash.local)'
        fi

    fi

    if [ -d "$RVM_DIRECTORY" ]; then

        [ -s "$RVM_DIR/scripts/rvm" ] \
          && source $RVM_DIR/scripts/rvm

        # Install ruby versions
        for i in ${NODE_VERSIONS[@]}; do

            execute "rvm --quiet-curl --install $i" "rvm (install: $i)"

        done

        execute "rvm use --default $RUBY_DEFAULT" "rvm (set default: $RUBY_DEFAULT)"

        execute "rvm cleanup all" "rvm (cleanup)"

    fi
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_ruby_versions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_ruby_versions
