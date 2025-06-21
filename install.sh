#!/bin/bash

echo "Installing NITJ WiFi Service..."
# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use 'sudo'."
    exit 1
fi

sudo mkdir -p /opt/my_services
sudo cp ./nitj_wifi_script.sh /opt/my_services/nitj_wifi_script.sh
sudo chmod +x /opt/my_services/nitj_wifi_script.sh
sudo cp ./nitj_wifi.service /etc/systemd/system/nitj_wifi.service

read -p "Enter your username for NITJ-WiFi : " username
sudo sed -i "s/usernameplaceholder/$username/g" /etc/systemd/system/nitj_wifi.service

read -p "Enter your password for NITJ-WiFi : " password
sudo sed -i "s/passwordplaceholder/$password/g" /etc/systemd/system/nitj_wifi.service

echo "Service has been installed, enabling and starting it now..."

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nitj_wifi
sudo systemctl start nitj_wifi

echo "Installation complete. The service has been enabled and started."