#!/usr/bin/env bash

export COMPUTER_NAME="Laptop"
export LOCAL_HOST_NAME="laptop"
export HOST_NAME="laptop.local"

export BASH_RC_LOCAL=~/.bashrc.local

if [[ "$(uname -s)" =~ ^Darwin ]]; then
  export OS="osx"
  export DOTFILES_DIR="$(readlink ~/.dotfiles)"
else
  export OS="ubuntu"
  export DOTFILES_DIR="$(readlink -f ~/.dotfiles)"
fi

# Dotfiles bin path
PATH=$DOTFILES_DIR/bin:/usr/local/bin:$PATH

_PATH=$PATH:;
PATH=
  
while [ -n "$_PATH" ]; do
  SEGMENT=${_PATH%%:*}       # the first remaining entry
  
  case $PATH: in
    *:"$SEGMENT":*) ;;         # already there
    *) PATH=$PATH:$SEGMENT;;    # not there yet
  esac
  
  _PATH=${_PATH#*:}
done

PATH=${PATH#:}
unset _PATH SEGMENT

export PATH;

export INPUT_RC=~/.inputrc

export GIT_CONF_LOCAL=~/.gitconfig.local

export CURL_RC=~/.curlrc

export DIR_COLORS=~/.dircolors
export TMUX_CONF=~/.tmux.conf

export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist
export NVM_DIR="$DOTFILES_DIR"/nvm
export NPM_RC=~/.npmrc

export RVM_DIR="$DOTFILES_DIR"/rvm
export GEM_RC=~/.gemrc

export VIM_DIR="$DOTFILES_DIR"/vim

export MYVIMRC=~/.vimrc
export MYVIMRC_LOCAL=~/.vimrc.local

export MYGVIMRC=~/.gvimrc
export MYGVIMRC_LOCAL=~/.gvimrc.local

export VIMINIT="source $MYVIMRC"

# Make vim the default editor
export EDITOR='vim'

# Ignore commands that start with spaces and duplicates
export HISTCONTROL=ignoreboth

# Increase the maximum number of lines contained in the
# history file (default value is 500)
export HISTFILESIZE=10000

# Don't add certain commands to the history file
export HISTIGNORE='&:[bf]g:c:clear:history:exit:q:pwd:* --help'

# Increase the maximum number of commands recorded in the
# command history (default value is 500)
export HISTSIZE=10000

# Prefer US English and use UTF-8 encoding
export LANG='en_US'
export LC_ALL='en_US.UTF-8'

# Use custom `less` colors for man pages
# https://www.gnu.org/software/termutils/manual/termutils-2.0/html_chapter/tput_1.html
export LESS_TERMCAP_md=$'\E[1;32m'   # begin bold mode
export LESS_TERMCAP_me=$'\E[0m'      # end bold mode
#export LESS_TERMCAP_us=$'\E[4;32m'   # begin underscore mode
#export LESS_TERMCAP_ue=$'\E[0m'      # end underscore mode

# Don't clear the screen after quitting a man page
export MANPAGER='less -X'

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

if [[ "$COLORTERM" == gnome-* && "$TERM" == xterm ]] && infocmp gnome-256color &> /dev/null; then
  export TERM='gnome-256color'
elif infocmp xterm-256color &> /dev/null; then
  export TERM='xterm-256color'
fi

if [ "${OS}" == 'osx' ]; then
  LSCOLORS=''
  LSCOLORS+='gx' # Directory
  LSCOLORS+='fx' # Symbolic link
  LSCOLORS+='cx' # Socket
  LSCOLORS+='dx' # Pipe
  LSCOLORS+='cx' # Executable
  LSCOLORS+='eg' # Block special
  LSCOLORS+='ed' # Character special
  LSCOLORS+='ab' # Executable with setuid bit set
  LSCOLORS+='ag' # Executable with setgid bit set
  LSCOLORS+='cc' # Directory writable to others, with sticky bit
  LSCOLORS+='bd' # Directory writable to others, without sticky bit

  export LSCOLORS
elif [ "${OS}" == 'ubuntu' ]; then
  LS_COLORS=''
  LS_COLORS+='no=0;39:'   # global default
  LS_COLORS+='di=0;36:'   # directory
  LS_COLORS+='ex=0;32:'   # executable file
  LS_COLORS+='fi=0;39:'   # file
  LS_COLORS+='ec=:'       # non-filename text
  LS_COLORS+='mi=1;31:'   # non-existent file pointed to by a symlink
  LS_COLORS+='ln=target:' # symbolic link
  LS_COLORS+='or=31;01'   # symbolic link pointing to a non-existent file

  export LS_COLORS
fi
