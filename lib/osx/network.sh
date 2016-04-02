#!/usr/bin/env bash

network_wifi() {
  sudo networksetup -setnetworkserviceenabled "Wi-Fi" "on" &> /dev/null
  sudo networksetup -setnetworkserviceenabled "Ethernet" "off" &> /dev/null

  print_success "Switched to WiFi. Ethernet can be unplugged"
}

network_eth() {
  sudo networksetup -setnetworkserviceenabled "Wi-Fi" "off" &> /dev/null
  sudo networksetup -setnetworkserviceenabled "Ethernet" "on" &> /dev/null

  print_success "WiFi turned off. Please plug in Ethernet"
}
