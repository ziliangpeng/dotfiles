#!/bin/bash

HOST=$(hostname -s)

# SSD lifetime bytes written
metric="macos.ssd.bytes_written:$(smartctl -a disk0 | grep 'Data Units Written' | awk '{print $4}' | tr -d ',' | awk '{print $1 * 512000}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# SSD lifetime bytes read
metric="macos.ssd.bytes_read:$(smartctl -a disk0 | grep 'Data Units Read' | awk '{print $4}' | tr -d ',' | awk '{print $1 * 512000}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# SSD percentage used (wear level)
metric="macos.ssd.percentage_used:$(smartctl -a disk0 | grep 'Percentage Used' | awk '{print $3}' | tr -d '%')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# SSD temperature
metric="macos.ssd.temperature:$(smartctl -a disk0 | grep 'Temperature:' | awk '{print $2}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# SSD power on hours
metric="macos.ssd.power_on_hours:$(smartctl -a disk0 | grep 'Power On Hours' | awk '{print $4}' | tr -d ',')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Disk usage bytes (root filesystem)
metric="macos.disk.usage_bytes:$(df -k / | tail -1 | awk '{print $3 * 1024}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Disk available bytes
metric="macos.disk.available_bytes:$(df -k / | tail -1 | awk '{print $4 * 1024}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# CPU load averages
metric="macos.cpu.load_1m:$(sysctl -n vm.loadavg | awk '{print $2}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

metric="macos.cpu.load_5m:$(sysctl -n vm.loadavg | awk '{print $3}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

metric="macos.cpu.load_15m:$(sysctl -n vm.loadavg | awk '{print $4}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Memory total bytes
metric="macos.memory.total_bytes:$(sysctl -n hw.memsize)"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Memory statistics from vm_stat
page_size=$(sysctl -n hw.pagesize)
vm_stat_output=$(vm_stat)

# Memory free bytes
metric="macos.memory.free_bytes:$(echo "$vm_stat_output" | grep 'Pages free' | awk '{print $3}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Memory active bytes
metric="macos.memory.active_bytes:$(echo "$vm_stat_output" | grep 'Pages active' | awk '{print $3}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Memory wired bytes
metric="macos.memory.wired_bytes:$(echo "$vm_stat_output" | grep 'Pages wired down' | awk '{print $4}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Memory compressed bytes
metric="macos.memory.compressed_bytes:$(echo "$vm_stat_output" | grep 'Pages occupied by compressor' | awk '{print $5}' | tr -d '.' | awk -v ps=$page_size '{print $1 * ps}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Swap used bytes
metric="macos.swap.used_bytes:$(sysctl -n vm.swapusage | awk '{print $7}' | tr -d 'M' | awk '{print $1 * 1048576}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Battery percentage
metric="macos.battery.percentage:$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Battery cycle count
metric="macos.battery.cycle_count:$(system_profiler SPPowerDataType | grep 'Cycle Count' | awk '{print $3}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Battery health percent
metric="macos.battery.health_percent:$(system_profiler SPPowerDataType | grep 'Maximum Capacity' | awk '{print $3}' | tr -d '%')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Battery is charging (1 if charging, 0 if not)
metric="macos.battery.is_charging:$(pmset -g batt | grep -q 'AC Power' && echo 1 || echo 0)"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Network total bytes received (sum of all interfaces)
metric="macos.network.bytes_in:$(netstat -ib | awk 'NR>1 && $7 ~ /^[0-9]+$/ {sum+=$7} END {print sum}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# Network total bytes sent (sum of all interfaces)
metric="macos.network.bytes_out:$(netstat -ib | awk 'NR>1 && $10 ~ /^[0-9]+$/ {sum+=$10} END {print sum}')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125

# System uptime in seconds
metric="macos.system.uptime_seconds:$(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',' | xargs -I {} bash -c 'echo $(($(date +%s) - {}))')"
echo "$metric"
echo "$metric:g|#host:$HOST" | nc -u -w0 localhost 8125
