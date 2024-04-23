while [[ "$SECONDS" -lt '3600' ]]; do
    link="$(curl -fs 'https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/Xiaomi.eu-app' | awk '/link/ && /app/' | sed -n 1p | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')"
    if [[ "$(cat ./link.txt)" != "$link" ]]; then
        echo "$link" > ./link.txt
        source ./json_generate.sh
    fi
    sleep 10
done
