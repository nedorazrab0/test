sudo apt update
apt search aapt
echo hui

#while true; do
link="$(curl -fs 'https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/Xiaomi.eu-app' | grep -om1 'https.*download')"
if [[ "$link" ]]; then
    echo hui > pif.json
    echo "$link" > ./link.txt
    source ./generate_json.sh
fi
#    sleep 10
#done
