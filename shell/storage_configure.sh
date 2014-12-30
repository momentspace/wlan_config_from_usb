#!/bin/bash
WLAN_IF="wlan0"
LOGFILE="/var/log/wlan_config.log"
WPA_PID="/var/run/wpa_supplicant.pid"
DHCLIENT_PID="/var/run/dhclient.$WLAN_IF.pid"
DHCLIENT_LEASE="/var/lib/dhcp/dhclient.$WLAN_IF.leases"

echo `date` " script called $0 $1 $DEVNAME" >> $LOGFILE

storage_mount() {
  # USBドングルがないとき
  
    # 処理終了
  
  
  # USBメモリが既にマウントされているとき
  if [[ `cat /proc/mounts | grep "usb_memory"` = "" ]]; then
    # アンマウントする
    echo `date` "usb memory was mounted. umount /dev/usb_memory." >> $LOGFILE 
    umount /dev/usb_memory
  fi
  
  # USBメモリをマウントする
  mount /dev/usb_memory /mnt/usb_memory
  
  # USBメモリにhostapd.confがあるとき
  if [ -e "/mnt/usb_memory/hostapd.conf" ]; then
    # アクセスポイントを起動する
    echo `date` "access point mode" >> $LOGFILE
  
  else
    # USBメモリにwpa_supplicant.confがあるとき
    if [ -e "/mnt/usb_memory/wpa_supplicant.conf" ]; then
      # 無線LANを繋ぎにいく
      echo `date` "client mode" >> $LOGFILE
      wpa_supplicant -i $WLAN_IF -c /mnt/usb_memory/wpa_supplicant.conf -Dwext >> $LOGFILE 2>&1 &
      echo $! > $WPA_PID

      # dhclientが動いていないとき
      if [ ! -e $DHCLIENT_PID ]; then
        # 無線LAN IFのIPをDHCPで取得する
        dhclient -v -pf $DHCLIENT_PID -lf $DHCLIENT_LEASE $WLAN_IF
        echo `date` "dhclient start for $WLAN_IF. $DHCLIENT_PID is not exist." >> $LOGFILE
      fi
    fi
  fi
}

storage_umount() {
  if [ -e "$WPA_PID" ]; then
    echo `date` "wpa_supplicant is running. kill them. file: $WPA_PID:" `cat $WPA_PID` >> $LOGFILE
    kill `cat "$WPA_PID"`
    rm $WPA_PID
  fi  
  if [ -e $DHCLIENT_PID ]; then
    echo `date` "dhclient is runnning. kill them. file: $DHCLIENT_PID: " `cat $DHCLIENT_PID` >> $LOGFILE
    kill `cat "$DHCLIENT_PID"`
    rm $DHCLIENT_PID
  fi
   umount /dev/usb_memory
}

case "$1" in
  start)
    echo `date` "start script $0 $1 $DEVNAME" >> $LOGFILE
    storage_mount
  ;;
  stop)
    echo `date` "stop script $0 $1 $DEVNAME" >> $LOGFILE
    storage_umount
  ;;
esac


