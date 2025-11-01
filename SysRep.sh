#!/bin/zsh

# Цвета
green='\033[0;32m'
yellow='\033[1;33m'
red='\033[0;31m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
bold='\033[1m'
reset='\033[0m'

line="=================================================================="

# CPU загрузка
cpu_usage=$(top -l 1 | awk -F'[:,]' '/CPU usage/ {print $2}' | awk '{print int($1)}')

# RAM
ram_line=$(top -l 1 | grep "PhysMem")
ram_g=$(echo "$ram_line" | grep -o '[0-9]*G' | grep -o '[0-9]*')
ram_m=$(echo "$ram_line" | grep -o '[0-9.]*M' | grep -o '[0-9]*')
if [[ -n $ram_g ]]; then
  used_mem=$(($ram_g * 1024))
elif [[ -n $ram_m ]]; then
  used_mem=$ram_m
else
  used_mem=0
fi
total_mem=$(system_profiler SPHardwareDataType | awk '/Memory:/ {print int($2*1024)}')

# Disk
disk_free=$(df -h / | awk 'END {print $4}')
disk_total=$(diskutil info / | grep "Total Size" | awk '{print $3 $4}')

# Uptime
uptime=$(uptime | awk -F", " '{print $1}')

# Battery
battery=$(pmset -g batt | grep "%" | awk '{print $3}' | sed 's/;//')
battery_cycles=$(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}')
battery_health=$(system_profiler SPPowerDataType | grep "Condition:" | awk '{print $2}')

# Network
ssid=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}')
ip=$(ipconfig getifaddr en0)

# Weather (Москва)
weather=$(curl -s "https://wttr.in/Moscow?format=2" | tr -d '\n')

# Date
datetime=$(date '+%Y-%m-%d %H:%M:%S')

# Модель, процессор (Apple Silicon/Intel)
model=$(system_profiler SPHardwareDataType | grep "Model Identifier" | awk '{print $3}')
cpu_type=$(system_profiler SPHardwareDataType | awk -F': ' '/Chip/ {print $2}')
cpu_speed=$(system_profiler SPHardwareDataType | grep "Processor Speed" | awk '{print $3 " " $4}')

# Проверка на пустой cpu_type (чтобы был вывод и для Intel)
if [[ -z $cpu_type ]]; then
  cpu_type=$(system_profiler SPHardwareDataType | grep "Processor Name" | cut -d: -f2 | xargs)
fi

# Вывод
echo "${bold}${cyan}$line${reset}"
printf "${bold}${blue}🖥️  MAC SYSTEM DASHBOARD      ${magenta}🗓️  %-22s${reset}\n" "$datetime"
echo "${cyan}$line${reset}"

printf "${blue} Модель:         ${bold}%s${reset}\n" "$model"
printf "${blue} CPU:            ${bold}%s${reset}\n" "$cpu_type"
printf "${yellow} 🕓 Uptime:      ${bold}%-32s${reset}\n" "$uptime"
printf "${magenta} 🌦 Weather:     ${bold}%-32s${reset}\n" "$weather"
printf "${blue} 🔥 CPU Usage:   ${bold}%3s%%${reset}\n" "$cpu_usage"
printf "${green} 💡 RAM Used:    ${bold}%4s MB / %-4s MB${reset}\n" "$used_mem" "$total_mem"
printf "${yellow} 💽 Disk:        ${bold}%-10s / %s${reset}\n" "$disk_free" "$disk_total"
[[ -n $battery ]] && printf "${magenta} 🔋 Battery:     ${bold}%-6s${reset}\n" "$battery"
printf "${magenta} 🔋 Бат. циклы:  ${bold}%s${reset}   🩺 статус: ${bold}%s${reset}\n" "${battery_cycles:-"-"}" "${battery_health:-"-"}"
printf "${cyan} 📶 WiFi:        ${bold}%-16s${reset} ${blue}IP: ${bold}%-16s${reset}\n" "${ssid:-"-"}" "${ip:-"-"}"
echo "${bold}${cyan}$line${reset}"
