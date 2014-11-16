#!/bin/bash
# Script to set the preferred wifi SSID and/or remove an unwanted SSID.
# hacked together by Matt Johnson @macitmatt


#Networks SSID you want to make the preferred network
preferrednetwork= corpwifi

#Network SSID(s) you want to ensure are removed from the list of preferred networks
removenetworks=( attwifi xfinitywifi linksys )


# Set the SSID specified in "preferrednetwork" as the preferred network by removing it and re-adding it
if [ -z "$preferrednetwork" ]
then
echo "No preferred SSID has been passed into the script, skipping this step..."
else
echo "Setting $preferrednetwork as the preferred WiFi network..."
wifi=`networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`
/usr/sbin/networksetup -removepreferredwirelessnetwork $wifi $preferrednetwork
/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $wifi $preferrednetwork 0 WPA2E NONE
fi

# Delete the SSID specified in Array removenetworks
for remove in "${removenetworks[@]}"
do
if [ -z "$remove" ]
then
echo "No SSID is set to be deleted"
else
ssidToDelete=`networksetup -listpreferredwirelessnetworks $wifi | grep $remove`
    if [ -z "$ssidToDelete" ]
    then
    echo "$remove isn't set up on this computer"
    else
    /usr/sbin/networksetup -removepreferredwirelessnetwork $wifi $ssidToDelete
    fi
fi
done
