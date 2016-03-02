#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Definitions

install_vagrant() {
	
	if cmd_exists 'brew'; then
        install_package 'Vagrant' 'vagrant'
    fi

	execute "vagrant plugin install vagrant-vbguest --plugin-source http://rubygems.org" "Vagrant vbguest plugin"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main

install_vagrant

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

unset install_vagrant
