# Mac System Dashboard

This zsh script provides a compact system dashboard for macOS, displaying key system metrics and status information in the terminal with color-coded output.

## Features

- CPU usage percentage
- RAM usage (used / total in MB)
- Disk free and total space on root filesystem
- System uptime
- Battery percentage, cycle count, and health status
- Connected WiFi SSID and IP address
- Current weather in Moscow (via wttr.in)
- Mac model identifier and CPU type
- Current date and time

## Requirements

- macOS system
- Built-in utilities: `top`, `awk`, `df`, `diskutil`, `uptime`, `pmset`, `system_profiler`, `networksetup`, `ipconfig`, `curl`
- Internet connection for weather retrieval

## Usage

1. Save the script file (e.g., `sysrep.sh`).
2. Make it executable:
```
chmod +x sysrep.sh
```
3. Run the script:
```
./sysrep.sh
```
The script outputs a colored dashboard directly to your terminal, summarizing your Mac's system status.

## Customization

Colors and formatting can be adjusted by modifying the escape codes and printf format strings within the script.

## License

This script is provided as-is without warranty. Use and modify as you like.

---