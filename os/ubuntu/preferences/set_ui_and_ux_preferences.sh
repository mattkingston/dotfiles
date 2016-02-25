#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_ui_and_ux_preferences() {

    print_info 'UI & UX'

    if gsettings list-recursively | grep -q "com.canonical.indicator.bluetooth"; then
        execute 'gsettings set com.canonical.indicator.bluetooth visible false' \
            'Hide bluetooth icon from the menu bar'
    fi

    if gsettings list-recursively | grep -q "com.canonical.indicator.sound"; then
        execute 'gsettings set com.canonical.indicator.sound visible false' \
            'Hide volume icon from the menu bar'
    fi

    if gsettings list-recursively | grep -q "com.canonical.indicator.power"; then
        execute 'gsettings set com.canonical.indicator.power icon-policy "charge" &&
                 gsettings set com.canonical.indicator.power show-time false' \
            'Hide battery icon from the menu bar when the battery is not in use'
    fi

    if gsettings list-recursively | grep -q "com.canonical.indicator.datetime"; then
        execute 'gsettings set com.canonical.indicator.datetime custom-time-format "%l:%M %p" &&
                 gsettings set com.canonical.indicator.datetime time-format "custom"' \
            'Use custom date format in the menu bar'
    fi

    if gsettings list-recursively | grep -q "org.gnome.desktop.background"; then
        execute 'gsettings set org.gnome.desktop.background picture-options "stretched"' \
            'Set desktop background image options'
    fi

        # execute 'gsettings set org.gnome.desktop.background picture-uri 'file:///home/...' &> /dev/null' \
        #     'Set desktop background image location'

    if gsettings list-recursively | grep -q "org.gnome.libgnomekbd.keyboard"; then
        execute "gsettings set org.gnome.libgnomekbd.keyboard layouts \"[ 'us' ]\"" \
            'Set keyboard languages'
    fi

    if gsettings list-recursively | grep -q "com.canonical.Unity.Launcher"; then
        execute "gsettings set com.canonical.Unity.Launcher favorites \"[
            'ubiquity-gtkui.desktop',
            'nautilus-home.desktop',
            'chromium-browser.desktop',
            'google-chrome.desktop',
            'firefox.desktop',
            'firefox-trunk.desktop',
            'opera-browser.desktop',
            'opera-next-browser.desktop'
        ]\"" \
            'Set Launcher favorites'
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_ui_and_ux_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_ui_and_ux_preferences
