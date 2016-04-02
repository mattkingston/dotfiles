#!/usr/bin/env bash

set_safari_preferences() {
  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Safari'

  execute 'defaults write com.apple.Safari AutoOpenSafeDownloads -bool false' \
    'Disable opening "safe" files automatically'

  execute 'defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool false' \
    'Disable backspace key from going to the previous page in history'

  execute 'defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true &&
     defaults write com.apple.Safari IncludeDevelopMenu -bool true &&
     defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true' \
    'Enable the "Develop" menu and the "Web Inspector"'

  execute 'defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false' \
    'Set search type to "Contains" instead of "Starts With"'

  execute 'defaults write com.apple.Safari HomePage -string "about:blank"' \
    'Set home page to "about:blank"'

  execute 'defaults write com.apple.Safari IncludeInternalDebugMenu -bool true' \
    'Enable "Debug" menu'

  execute 'defaults write com.apple.Safari ShowFavoritesBar -bool true' \
    'Show bookmarks bar by default'

  execute 'defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true' \
    'Show the full URL in the address bar'

  execute 'defaults write com.apple.Safari SuppressSearchSuggestions -bool true &&
           defaults write com.apple.Safari UniversalSearchEnabled -bool false' \
    'Don’t send search queries to Apple'

  execute 'defaults write NSGlobalDomain WebKitDeveloperExtras -bool true' \
    'Add a context menu item for showing the "Web Inspector" in web views'

  killall 'Safari' &> /dev/null

  cd "${pwd}"
}

set_safari_preferences

unset set_safari_preferences