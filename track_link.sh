while true; do
    link="$(curl -fs 'https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/Xiaomi.eu-app' | grep -om1 'https.*download')"
    if [[ "$(cat ./link.txt)" != "$link" ]]; then
        echo "$link" > ./link.txt
        source ./json_generate.sh
    fi
    sleep 10
done
