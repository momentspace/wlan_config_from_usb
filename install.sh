#!/bin/sh
mkdir /mnt/usb_memory
cp shell/storage_configure.sh /usr/local/bin/
cp rules/50-usb-memory.rules /etc/udev/rules.d/
echo ""
echo "target wlan device(ex. wlan0) setting off to interfaces."
echo " and killall wpa_supplicant."
echo ""
echo " -- interfaces --"
echo " # iface wlan0 inet manual "
echo " # wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf"
echo " -- killall wpa_supplicant --"
echo " # sudo killall wpa_supplicant"
echo ""
