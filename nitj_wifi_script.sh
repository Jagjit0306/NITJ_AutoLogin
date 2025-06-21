#!/bin/bash

# Check internet connectivity by pinging Google DNS
if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    echo "Internet is connected. $(date)" >> /tmp/nitj_wifi.log
    exit 0
fi

echo "Internet is not connected. $(date)" >> /tmp/nitj_wifi.log

# Get current WiFi SSID (works with NetworkManager)
SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# Try connecting to NITJ-WiFi(Open Network), if in range
if [ -z "$SSID" ]; then
    echo "No WiFi connection found. Attempting to connect to NITJ-WiFi. $(date)" >> /tmp/nitj_wifi.log
    nmcli dev wifi connect "NITJ-WiFi" || { echo "Failed to connect to NITJ-WiFi. $(date)" >> /tmp/nitj_wifi.log; exit 1; }
else
    echo "Currently connected to SSID: $SSID. $(date)" >> /tmp/nitj_wifi.log
fi

# If connected to some other network, then disconnect and try connecting to NITJ-WiFi, but only if NITJ-WiFi is in range
if [ "$SSID" != "NITJ-WiFi" ]; then
    if nmcli -t -f SSID dev wifi | grep -Fxq "NITJ-WiFi"; then
        echo "NITJ-WiFi is in range. Disconnecting from $SSID and connecting to NITJ-WiFi. $(date)" >> /tmp/nitj_wifi.log
        nmcli dev disconnect wlan0 || { echo "Failed to disconnect from $SSID. $(date)" >> /tmp/nitj_wifi.log; exit 1; }
        nmcli dev wifi connect "NITJ-WiFi" || { echo "Failed to connect to NITJ-WiFi. $(date)" >> /tmp/nitj_wifi.log; exit 1; }
    else
        echo "NITJ-WiFi is not in range. Skipping connection attempt. $(date)" >> /tmp/nitj_wifi.log
    fi
fi

if [ "$SSID" = "NITJ-WiFi" ]; then
    echo "Connected to NITJ-WiFi, attempting login. $(date)" >> /tmp/nitj_wifi.log

    curl -X POST "http://10.10.11.1:8090/httpclient.html" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "mode=191&username=$username&password=$password&producttype=0"

    echo "Connection to NITJ-WiFi, successful ! $(date)" >> /tmp/nitj_wifi.log
fi

sleep 5


# Future improvments:
# iface=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep ":wifi:connected" | cut -d: -f1)
# nmcli dev disconnect "$iface"