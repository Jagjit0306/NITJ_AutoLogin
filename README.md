# NITJ WiFi Auto-Login Script

This is a simple Bash-based automation script that connects to the `NITJ-WiFi` network and performs the captive portal login automatically. It uses a `systemd` service to ensure the script runs on startup or whenever there is no active internet connection.

---

## File Structure

```

NITJ_AutoLogin/
├── nitj\_wifi.service       # systemd service file
├── nitj\_wifi\_script.sh     # main auto-login script
├── install.sh              # installs and enables the systemd service
├── uninstall.sh            # disables and removes the systemd service

````

---

## Installation

Ensure `nmcli` and `curl` are installed on your system.

1. Open a terminal in the project directory.
2. Make the install script executable and run it:

```bash
chmod +x install.sh
./install.sh
````

This will:

* Move the script and service file to appropriate system directories.
* Set up user credentials.
* Enable and start the `systemd` service.

---

## Uninstallation

To remove the service and related files:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

---

## Logs

The script logs its actions and status messages to:

```
/tmp/nitj_wifi.log
```

To view logs in real-time:

```bash
tail -f /tmp/nitj_wifi.log
```

---

## How It Works

* Checks for internet connectivity.
* If no internet is detected:

  * Connects to `NITJ-WiFi` if not already connected.
  * Disconnects from other networks if necessary.
  * Sends a login request to the captive portal.
* All steps are logged for monitoring or debugging purposes.

---

## Tested On

* Ubuntu 22.04
* Fedora 38
* Raspberry Pi OS (Bookworm)

---

## License

This project is licensed under the [MIT License](./LICENSE).
