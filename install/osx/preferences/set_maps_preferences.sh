#!/usr/bin/env bash

set_maps_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Maps'

  execute 'defaults write com.apple.Maps LastClosedWindowViewOptions "{
              localizeLabels = 1;   // show labels in English
              mapType = 11;         // show hybrid map
              trafficEnabled = 0;   // do not show traffic
           }"' \
    'Set view options'

  killall 'Maps' &> /dev/null
}

set_maps_preferences

unset set_maps_preferences