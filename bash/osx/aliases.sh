#!/usr/bin/env bash

# Colorful ls

alias ls='ls -G' # or CLICOLOR=1

# Lock screen

alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# Empty the trash, the main HDD and on all mounted volumes
# and clear Apple’s system logs to improve shell startup speed

alias empty_trash='\
  sudo rm -frv /Volumes/*/.Trashes \
    && sudo rm -frv ~/.Trash \
    && sudo rm -frv /private/var/log/asl/*.asl'

# Hide/Show desktop icons

alias hide_desktop_icons='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias show_desktop_icons='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'

# Hide/Show hidden files in Finder

alias hide_hidden_files='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias show_hidden_files='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'

# Copy to clipboard

alias cc='pbcopy'