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

# Get precipitation
precip_raw=$(curl -s "wttr.in/?format=%p" 2>/dev/null)
precip=$(echo "$precip_raw" | tr -d 'mm' | xargs)
if [ -n "$precip" ] && [ "$precip" != "" ]; then
    metric="macos.geo.precipitation:$precip"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Get UV index
uv=$(curl -s "wttr.in/?format=%u" 2>/dev/null | xargs)
if [ -n "$uv" ] && [ "$uv" != "" ]; then
    metric="macos.geo.uv_index:$uv"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Get moon phase (0-29 day cycle)
moon=$(curl -s "wttr.in/?format=%M" 2>/dev/null | xargs)
if [ -n "$moon" ] && [ "$moon" != "" ]; then
    metric="macos.geo.moon_phase:$moon"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

# Get sunrise and sunset times
sunrise_raw=$(curl -s "wttr.in/?format=%S" 2>/dev/null)
sunset_raw=$(curl -s "wttr.in/?format=%s" 2>/dev/null)

# Convert HH:MM:SS to decimal hours for easier graphing
if [ -n "$sunrise_raw" ] && [ "$sunrise_raw" != "" ]; then
    sunrise_hour=$(echo "$sunrise_raw" | awk -F: '{print $1 + $2/60 + $3/3600}')
    metric="macos.geo.sunrise_hour:$sunrise_hour"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
fi

if [ -n "$sunset_raw" ] && [ "$sunset_raw" != "" ]; then
    sunset_hour=$(echo "$sunset_raw" | awk -F: '{print $1 + $2/60 + $3/3600}')
    metric="macos.geo.sunset_hour:$sunset_hour"
    echo "$metric"
    printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125

    # Calculate day length (hours of daylight)
    if [ -n "$sunrise_hour" ]; then
        day_length=$(echo "$sunset_hour - $sunrise_hour" | bc)
        metric="macos.geo.day_length:$day_length"
        echo "$metric"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi
fi
