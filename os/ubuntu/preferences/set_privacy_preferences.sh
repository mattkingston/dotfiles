#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

set_privacy_preferences() {

    print_info 'Privacy'

    execute 'gsettings set com.canonical.Unity.Lenses remote-content-search "none"' \
        'Turn off "Remote Search" so that search terms in Dash do not get sent over the internet'

    execute 'gsettings set com.canonical.Unity.ApplicationsLens display-available-apps false' \
        'Disable Dash "More suggestions" section'

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

set_privacy_preferences

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset set_privacy_preferences
