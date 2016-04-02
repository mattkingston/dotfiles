#!/usr/bin/env bash

set_transmission_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Transmission'

  execute 'defaults write org.m0k.transmission DeleteOriginalTorrent -bool true' \
    'Delete the original torrent files'

  execute 'defaults write org.m0k.transmission DownloadAsk -bool false' \
    'Don’t prompt for confirmation before downloading'

  execute 'defaults write org.m0k.transmission DownloadChoice -string "Constant" &&
       defaults write org.m0k.transmission DownloadFolder -string "$HOME/Downloads"' \
    'Use "~/Downloads" to store complete downloads'

  execute 'defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true &&
       defaults write org.m0k.transmission IncompleteDownloadFolder -string "$HOME/Downloads/torrents"' \
    'Use "~/Downloads/torrents" to store incomplete downloads'

  execute 'defaults write org.m0k.transmission WarningDonate -bool false' \
    'Hide the donate message'

  execute 'defaults write org.m0k.transmission WarningLegal -bool false' \
    'Hide the legal disclaimer'

  killall 'Transmission' &> /dev/null

  cd "${pwd}"
}

set_transmission_preferences

unset set_transmission_preferences
