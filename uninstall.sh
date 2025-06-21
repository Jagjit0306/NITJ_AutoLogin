echo "Uninstalling NITJ WiFi Service..."
# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use 'sudo'."
    exit 1
fi

sudo systemctl stop nitj_wifi
sudo systemctl disable nitj_wifi
sudo rm /etc/systemd/system/nitj_wifi.service
sudo rm /opt/my_services/nitj_wifi_script.sh
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "Uninstallation complete. The service has been stopped and removed."