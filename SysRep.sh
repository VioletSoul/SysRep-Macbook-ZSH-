#!/bin/zsh

green='\033[0;32m'     # Green color
yellow='\033[1;33m'    # Yellow color
red='\033[0;31m'       # Red color
blue='\033[0;34m'      # Blue color
magenta='\033[0;35m'   # Magenta color
cyan='\033[0;36m'      # Cyan color
bold='\033[1m'         # Bold text style
reset='\033[0m'        # Reset formatting

line="=================================================================="  # Output separator

cpu_usage=$(top -l 1 | awk -F'[:,]' '/CPU usage/ {print $2}' | awk '{print int($1)}')   # CPU usage percent integer

ram_line=$(top -l 1 | grep "PhysMem")                                                  # RAM usage line
ram_g=$(echo "$ram_line" | grep -o '[0-9]*G' | grep -o '[0-9]*')                      # RAM used in GB
ram_m=$(echo "$ram_line" | grep -o '[0-9.]*M' | grep -o '[0-9]*')                     # RAM used in MB

if [[ -n $ram_g ]]; then used_mem=$(($ram_g * 1024))                                  # Convert GB to MB
elif [[ -n $ram_m ]]; then used_mem=$ram_m                                            # Use MB value
else used_mem=0
fi

total_mem=$(system_profiler SPHardwareDataType | awk '/Memory:/ {print int($2*1024)}') # Total RAM in MB

disk_free=$(df -h / | awk 'END {print $4}')                                           # Free disk space on root
disk_total=$(diskutil info / | grep "Total Size" | awk '{print $3 $4}')                # Total disk size

uptime=$(uptime | awk -F", " '{print $1}')                                            # System uptime (short)

battery=$(pmset -g batt | grep "%" | awk '{print $3}' | sed 's/;//')                  # Battery percent
battery_cycles=$(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}')   # Battery cycle count
battery_health=$(system_profiler SPPowerDataType | grep "Condition:" | awk '{print $2}')   # Battery health status

ssid=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}')     # WiFi SSID
ip=$(ipconfig getifaddr en0)                                                          # IP address on en0

weather=$(curl -s "https://wttr.in/Moscow?format=2" | tr -d '\n')                      # Current weather in Moscow

datetime=$(date '+%Y-%m-%d %H:%M:%S')                                                 # Current date and time

model=$(system_profiler SPHardwareDataType | grep "Model Identifier" | awk '{print $3}') # Mac model
cpu_type=$(system_profiler SPHardwareDataType | awk -F': ' '/Chip/ {print $2}')          # CPU chip type
cpu_speed=$(system_profiler SPHardwareDataType | grep "Processor Speed" | awk '{print $3 " " $4}')  # CPU speed

if [[ -z $cpu_type ]]; then
  cpu_type=$(system_profiler SPHardwareDataType | grep "Processor Name" | cut -d: -f2 | xargs)  # Fallback for Intel CPU type
fi

echo "${bold}${cyan}$line${reset}"
printf "${bold}${blue}🖥️  MAC SYSTEM DASHBOARD      ${magenta}🗓️  %-22s${reset}\n" "$datetime"
echo "${cyan}$line${reset}"

printf "${blue} Model:         ${bold}%s${reset}\n" "$model"
printf "${blue} CPU:           ${bold}%s${reset}\n" "$cpu_type"
printf "${yellow} 🕓 Uptime:     ${bold}%-32s${reset}\n" "$uptime"
printf "${magenta} 🌦 Weather:    ${bold}%-32s${reset}\n" "$weather"
printf "${blue} 🔥 CPU Usage:  ${bold}%3s%%${reset}\n" "$cpu_usage"
printf "${green} 💡 RAM Used:   ${bold}%4s MB / %-4s MB${reset}\n" "$used_mem" "$total_mem"
printf "${yellow} 💽 Disk:       ${bold}%-10s / %s${reset}\n" "$disk_free" "$disk_total"
[[ -n $battery ]] && printf "${magenta} 🔋 Battery:    ${bold}%-6s${reset}\n" "$battery"
printf "${magenta} 🔋 Battery Cycles: ${bold}%s${reset}   🩺 Health Status: ${bold}%s${reset}\n" "${battery_cycles:-"-"}" "${battery_health:-"-"}"
printf "${cyan} 📶 WiFi:       ${bold}%-16s${reset} ${blue}IP: ${bold}%-16s${reset}\n" "${ssid:-"-"}" "${ip:-"-"}"
echo "${bold}${cyan}$line${reset}"
