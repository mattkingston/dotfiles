#!/usr/bin/env bash

set_textedit_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'TextEdit'

  execute 'defaults write com.apple.TextEdit PlainTextEncoding -int 4 &&
           defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4' \
    'Open and save files as UTF-8 encoded'

  execute 'defaults write com.apple.TextEdit RichText -' \
    'Use plain text mode for new documents'

  execute 'defaults write com.apple.TextEdit SmartQuotes -bool false' \
    'Disable smart quotes for Text Edit'

  execute 'defaults write com.apple.TextEdit SmartDashes -bool false' \
    'Disable smart dashes for Text Edit'

  killall 'TextEdit' &> /dev/null
}

set_textedit_preferences

unset set_textedit_preferences
