#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Variables

declare -a FILES_TO_SYMLINK=(
    'shell/ackrc'

    'shell/bash_aliases'
    'shell/bash_exports'
    'shell/bash_extra'
    'shell/bash_functions'
    'shell/bash_logout'
    'shell/bash_options'
    'shell/bash_prompt'
    'shell/bash_profile'
    'shell/bash_utils'

    'shell/curlrc'

    'shell/gemrc'

    'shell/gitattributes'
    'shell/gitconfig'
    'shell/gitignore'

    'shell/gvimrc'

    'shell/inputrc'

    'shell/npmrc'

    'shell/screenrc'

    'shell/tmux.conf'

    'shell/vim'
    'shell/vimrc'
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

create_symbolic_links() {

    local i=''
    local sourceFile=''
    local targetFile=''
    
    local workingDirectory="$(pwd)" \
        && cd "$(dirname $BASH_SOURCE)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in ${FILES_TO_SYMLINK[@]}; do

        sourceFile="$(cd .. && pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
        
        echo "$sourceFile"

        if [ ! -e "$targetFile" ]; then
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else
            ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"

            if answer_is_yes; then
                rm -rf "$targetFile"
                execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
            else
                print_error "$targetFile → $sourceFile"
            fi
        fi

    done
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    cd "$workingDirectory"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

create_symbolic_links

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset create_symbolic_links
