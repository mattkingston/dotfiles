#!/usr/bin/env bash

# Colorful ls

if [ -x "/usr/bin/dircolors" ]; then
  test -r "${DIR_COLORS}" \
    && eval "$(dircolors -b ${DIR_COLORS})" \
    || eval "$(dircolors -b)"

  alias dir='dir --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias grep='grep --color=auto'
  alias ls='ls --color=auto'
  alias vdir='vdir --color=auto'
fi

# Lock screen

alias akf='gnome-screensaver-command --lock'

# Hide/Show desktop icons

alias hide_desktop_icons='gsettings set org.gnome.desktop.background show-desktop-icons false'
alias show_desktop_icons='gsettings set org.gnome.desktop.background show-desktop-icons true'

# Copy to clipboard

alias cc='xclip -selection clip'
