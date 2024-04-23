while [[ "$SECONDS" -lt '21570' ]]; do
    link="$(curl -fs https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/Xiaomi.eu-app | awk '/link/ && /app/' | sed -n 1p | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')"
    if ! [[ "$(cat ./link.txt)" == "$link" || -f ./link.txt ]]; then
        echo "$link" > ./link.txt
        curl -fsLo ./euapp.apk "$link"
        apktool d --no-assets -fsbo ./euapp/ ./euapp.apk

        # generate pif.json
        echo '{' > pif.json
        for val in PRODUCT DEVICE MANUFACTURER BRAND MODEL FINGERPRINT SECURITY_PATCH FIRST_API_LEVEL; do
            key="$(grep "$val" ./euapp/res/xml/inject_fields.xml | awk -F 'value=' '{print $2}' | awk '{print $1}')"
            echo "\"$val\": ${key:-\"null\"}," >> pif.json
            [[ "$val" == 'FIRST_API_LEVEL' ]] && sed -i '9s/.$//' ./pif.json
        done
        echo '}' >> pif.json

        # release pif.json
        git config --global user.name 'github-actions'
        git config --global user.email 'github-actions@github.com'
        git add ./link.txt ./pif.json
        git commit -m "New pif.json"
        git push
    fi
    sleep 10
done
