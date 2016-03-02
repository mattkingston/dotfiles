#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_vim_plugins() {

    # Check if `Git` is installed
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE[0])"

    if ! cmd_exists 'git'; then
        print_error 'Git is required, please install it!\n'
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install / Update vim plugins

    rm -rf ~/.vim/plugins/Vundle.vim &> /dev/null \
        && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/plugins/Vundle.vim &> /dev/null \
        && printf "\n" | vim +PluginInstall +qall 2> /dev/null
        #     └─ simulate the ENTER keypress for
        #        the case where there are warnings
    print_result $? 'Install Vim plugins'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # In the case of fresh installs, in order for `npm` to be
    # available, # the `~/bash.local` file needs to be sourced

    if ! cmd_exists 'npm'; then
        [ -f "$HOME/.bash.local" ] \
          && source "$HOME/.bash.local"
    fi

    # cd ~/.vim/plugins/tern_for_vim \
    #     && npm install &> /dev/null
    
    # print_result $? 'tern_for_vim (extra installations)'
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_vim_plugins

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_vim_plugins
