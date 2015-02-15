#!/bin/sh
mkdir /mnt/usb_memory
cp shell/storage_configure.sh /usr/local/bin/
cp rules/50-usb-memory.rules /etc/udev/rules.d/

