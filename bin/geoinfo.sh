#!/bin/bash

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
HOST=$(hostname -s)

# Get temperature in Celsius
temp_raw=$(curl -s "wttr.in/?format=%t&m" 2>/dev/null)
temp=$(echo "$temp_raw" | tr -d '+°C' | xargs)
if [ -n "$temp" ] && [ "$temp" != "" ]; then
    metric="macos.geo.temperature_celsius:$temp"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Get humidity
humidity_raw=$(curl -s "wttr.in/?format=%h" 2>/dev/null)
humidity=$(echo "$humidity_raw" | tr -d '%' | xargs)
if [ -n "$humidity" ] && [ "$humidity" != "" ]; then
    metric="macos.geo.humidity:$humidity"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Get wind speed (in mph)
wind_raw=$(curl -s "wttr.in/?format=%w" 2>/dev/null)
# Extract just the number from something like "←2mph" or "→15mph"
wind=$(echo "$wind_raw" | grep -o '[0-9]\+' | head -1)
if [ -n "$wind" ] && [ "$wind" != "" ]; then
    metric="macos.geo.wind_speed:$wind"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Get weather condition
condition_raw=$(curl -s "wttr.in/?format=%C" 2>/dev/null)
if [ -n "$condition_raw" ] && [ "$condition_raw" != "" ]; then
    # Sanitize for tag (lowercase, replace spaces with underscores)
    condition_tag=$(echo "$condition_raw" | tr 'A-Z' 'a-z' | tr ' ' '_')
    metric="macos.geo.weather:1"
    echo "$metric (condition:$condition_tag)"
    printf "%s|g|#host:%s,condition:%s\n" "$metric" "$HOST" "$condition_tag" | nc -u -w1 localhost 8125
fi
