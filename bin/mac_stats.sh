#!/bin/bash

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
HOST=$(hostname -s)

# SSD lifetime bytes written
metric="macos.ssd.bytes_written:$(smartctl -a disk0 | grep 'Data Units Written' | awk '{print $4}' | tr -d ',' | awk '{print $1 * 512000}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# SSD lifetime bytes read
metric="macos.ssd.bytes_read:$(smartctl -a disk0 | grep 'Data Units Read' | awk '{print $4}' | tr -d ',' | awk '{print $1 * 512000}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# SSD percentage used (wear level)
metric="macos.ssd.percentage_used:$(smartctl -a disk0 | grep 'Percentage Used' | awk '{print $3}' | tr -d '%')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# SSD temperature
metric="macos.ssd.temperature:$(smartctl -a disk0 | grep 'Temperature:' | awk '{print $2}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# SSD power on hours
metric="macos.ssd.power_on_hours:$(smartctl -a disk0 | grep 'Power On Hours' | awk '{print $4}' | tr -d ',')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Disk usage bytes (user data volume)
metric="macos.disk.usage_bytes:$(df -k /System/Volumes/Data | tail -1 | awk '{print $3 * 1024}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Disk available bytes
metric="macos.disk.available_bytes:$(df -k /System/Volumes/Data | tail -1 | awk '{print $4 * 1024}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Disk total capacity
metric="macos.disk.total_bytes:$(df -k /System/Volumes/Data | tail -1 | awk '{print $2 * 1024}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Disk usage percentage
metric="macos.disk.usage_percent:$(df -k /System/Volumes/Data | tail -1 | awk '{print $5}' | tr -d '%')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# CPU load averages
metric="macos.cpu.load_1m:$(sysctl -n vm.loadavg | awk '{print $2}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

metric="macos.cpu.load_5m:$(sysctl -n vm.loadavg | awk '{print $3}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

metric="macos.cpu.load_15m:$(sysctl -n vm.loadavg | awk '{print $4}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Memory total bytes
metric="macos.memory.total_bytes:$(sysctl -n hw.memsize)"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Memory statistics from vm_stat
page_size=$(sysctl -n hw.pagesize)
vm_stat_output=$(vm_stat)

# Memory free bytes
metric="macos.memory.free_bytes:$(echo "$vm_stat_output" | grep 'Pages free' | awk '{print $3}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Memory active bytes
metric="macos.memory.active_bytes:$(echo "$vm_stat_output" | grep 'Pages active' | awk '{print $3}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Memory wired bytes
metric="macos.memory.wired_bytes:$(echo "$vm_stat_output" | grep 'Pages wired down' | awk '{print $4}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Memory compressed bytes
metric="macos.memory.compressed_bytes:$(echo "$vm_stat_output" | grep 'Pages occupied by compressor' | awk '{print $5}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Swap used bytes
metric="macos.swap.used_bytes:$(sysctl -n vm.swapusage | awk '{print $7}' | tr -d 'M' | awk '{print $1 * 1048576}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Battery percentage
metric="macos.battery.percentage:$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Battery cycle count
metric="macos.battery.cycle_count:$(system_profiler SPPowerDataType | grep 'Cycle Count' | awk '{print $3}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Battery health percent
metric="macos.battery.health_percent:$(system_profiler SPPowerDataType | grep 'Maximum Capacity' | awk '{print $3}' | tr -d '%')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Battery is charging (1 if charging, 0 if not)
metric="macos.battery.is_charging:$(pmset -g batt | grep -q 'AC Power' && echo 1 || echo 0)"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Network total bytes received (sum of all interfaces)
metric="macos.network.bytes_in:$(netstat -ib | awk 'NR>1 && $7 ~ /^[0-9]+$/ {sum+=$7} END {print sum}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Network total bytes sent (sum of all interfaces)
metric="macos.network.bytes_out:$(netstat -ib | awk 'NR>1 && $10 ~ /^[0-9]+$/ {sum+=$10} END {print sum}')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# System uptime in seconds
metric="macos.system.uptime_seconds:$(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',' | xargs -I {} bash -c 'echo $(($(date +%s) - {}))')"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# WiFi stats - Get WiFi information for connected network
wifi_info=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Status: Connected/,/Other Local Wi-Fi Networks:/' | grep -v "Other Local Wi-Fi Networks:")

# Only collect WiFi stats if connected
if [ -n "$wifi_info" ]; then
    # Extract signal and noise (format: "Signal / Noise: -65 dBm / -89 dBm")
    signal=$(echo "$wifi_info" | grep "Signal / Noise:" | head -1 | awk '{print $4}')
    noise=$(echo "$wifi_info" | grep "Signal / Noise:" | head -1 | awk '{print $7}')

    # WiFi signal strength
    if [ -n "$signal" ]; then
        metric="macos.wifi.signal_strength:$signal"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi

    # WiFi noise level
    if [ -n "$noise" ]; then
        metric="macos.wifi.noise_level:$noise"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi

    # WiFi transmit rate (Mbps)
    transmit_rate=$(echo "$wifi_info" | grep "Transmit Rate:" | head -1 | awk '{print $3}')
    if [ -n "$transmit_rate" ]; then
        metric="macos.wifi.transmit_rate:$transmit_rate"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi

    # WiFi channel number
    channel=$(echo "$wifi_info" | grep "Channel:" | head -1 | awk '{print $2}')
    if [ -n "$channel" ]; then
        metric="macos.wifi.channel:$channel"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi
fi

# Bluetooth stats
bt_info=$(system_profiler SPBluetoothDataType 2>/dev/null)

# Bluetooth connected device count
connected_count=$(echo "$bt_info" | awk '/Connected:/,/Not Connected:/ {if (/Minor Type:/) count++} END {print count+0}')
metric="macos.bluetooth.connected_count:$connected_count"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Bluetooth paired device count
paired_count=$(echo "$bt_info" | grep -c "Address:")
paired_count=$((paired_count - 1))
metric="macos.bluetooth.paired_count:$paired_count"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# PPP3 AirPods battery levels
ppp3_section=$(echo "$bt_info" | awk '/PPP3:/,/Services:/')
ppp3_left=$(echo "$ppp3_section" | grep "Left Battery Level:" | tail -1 | awk '{print $4}' | tr -d '%')
ppp3_right=$(echo "$ppp3_section" | grep "Right Battery Level:" | tail -1 | awk '{print $4}' | tr -d '%')
ppp3_case=$(echo "$ppp3_section" | grep "Case Battery Level:" | tail -1 | awk '{print $4}' | tr -d '%')

if [ -n "$ppp3_left" ]; then
    metric="macos.bluetooth.ppp3_battery_left:$ppp3_left"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

if [ -n "$ppp3_right" ]; then
    metric="macos.bluetooth.ppp3_battery_right:$ppp3_right"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

if [ -n "$ppp3_case" ]; then
    metric="macos.bluetooth.ppp3_battery_case:$ppp3_case"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Connected device types
connected_devices=$(echo "$bt_info" | awk '/Connected:/,/Not Connected:/ {print}')

mice_count=$(echo "$connected_devices" | grep -c "Minor Type: Mouse")
metric="macos.bluetooth.connected_mice:$mice_count"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

keyboards_count=$(echo "$connected_devices" | grep -c "Minor Type: Keyboard")
metric="macos.bluetooth.connected_keyboards:$keyboards_count"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

headphones_count=$(echo "$connected_devices" | grep -c "Minor Type: Headphones")
metric="macos.bluetooth.connected_headphones:$headphones_count"
echo "$metric"
printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

# Comet browser metrics (only if running)
if pgrep -q "Comet"; then
    # Comet tab count
    tab_count=$(osascript -e 'tell application "Comet" to count every tab of every window' 2>/dev/null)
    if [ -n "$tab_count" ]; then
        metric="macos.comet.tab_count:$tab_count"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi

    # Comet window count
    window_count=$(osascript -e 'tell application "Comet" to count every window' 2>/dev/null)
    if [ -n "$window_count" ]; then
        metric="macos.comet.window_count:$window_count"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi
fi