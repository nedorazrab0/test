# get apk
curl -fsZLo ./euapp.apk "$link"

aapt dump xmltree euapp.apk --file res/xml/inject_fields.xml 

aapt dump xmltree euapp.apk --file res/xml/inject_fields.xml > ./hui.xml
# generate json
echo '{' > pif.json
for val in PRODUCT DEVICE MANUFACTURER BRAND MODEL FINGERPRINT SECURITY_PATCH FIRST_API_LEVEL; do
    key="$(grep -A2 "$val" ./hui.xml | sed -n 3p | awk -F 'value=' '{print $2}' | awk '{print $1}')"
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
