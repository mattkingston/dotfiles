#!/usr/bin/env bash

set_terminal_preferences() {
  local pwd="$(pwd)"

  cd "$(dirname "${0}")"

  . ~/.dotfiles/bin/dotfiles

  print_subtitle 'Terminal'

  if gsettings list-recursively | grep -q "org.gnome.desktop.interface"; then
    execute 'gsettings set org.gnome.desktop.interface monospace-font-name "Monospace 12"' \
      'Change font size'
  fi

  if is_callable 'gconftool-2'; then
    execute '
      gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false \
        && gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false \
        && gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#00002B2B3636:#CBCB4B4B1616:#58586E6E7575:#65657B7B8383:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3" \
        && gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#00002B2B3636" \
        && gconftool-2 --set "/apps/gnome-terminal/profiles/Default/foreground_color" --type string "#65657B7B8383"' \
      'Set custom terminal theme'
  fi

  cd "${pwd}"
}

set_terminal_preferences

unset set_terminal_preferences
