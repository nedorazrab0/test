
# get apk
curl -fsZLo ./euapp.apk "$link"

#aapt dump xmltree euapp.apk res/xml/inject_fields.xml 

aapt dump xmltree euapp.apk res/xml/inject_fields.xml > ./hui.xml
echo -n > ./pif.json
# generate json
for val in BRAND MANUFACTURER PRODUCT DEVICE MODEL SECURITY_PATCH FINGERPRINT; do
    key="$(grep -A2 "$val" ./hui.xml | sed -n 3p | awk -F \" '{print $2}')"
    echo "$val ${key:-null}" >> pif.json
done

echo 'TYPE user' >> ./pif.json
echo 'TAGS release-keys' >> ./pif.json
echo "ID $(grep 'FINGERPRINT' ./pif.json | awk -F '/' '{print $4}')" >> ./pif.json
echo "INCREMENTAL $(grep 'FINGERPRINT' ./pif.json | awk -F '/' '{print $5}' | awk -F ':' '{print $1}')" >> ./pif.json
echo "RELEASE $(grep 'FINGERPRINT' ./pif.json | awk -F '/' '{print $3}' | awk -F ':' '{print $2}')" >> ./pif.json
apilvl="$(grep -A2 "FIRST_API_LEVEL" ./hui.xml | sed -n 3p | awk -F \" '{print $2}')"
if [[ "$apilvl" == 'null' ]]; then
    echo 'DEVICE_INITIAL_SDK_INT 25' >> ./pif.json
else
    echo "DEVICE_INITIAL_SDK_INT $apilvl" >> pif.json
fi

awk -i inplace '{printf "    \"%s\": \"%s\"\,\n", $1, $2}' ./pif.json
sed -i '1i\{' ./pif.json
sed -i '$s/.$//' ./pif.json
echo '}' >> ./pif.json
# release pif.json
git config --global user.name 'github-actions'
git config --global user.email 'github-actions@github.com'
git add ./link.txt ./pif.json
git commit -m "New pif.json"
git push
