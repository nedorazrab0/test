sudo apt update
sudo apt install apktool -y

echo '{' > huj
for val in PRODUCT DEVICE MANUFACTURER BRAND MODEL FINGERPRINT SECURITY_PATCH FIRST_API_LEVEL; do
key="$(grep "$val" ./res/xml/inject_fields.xml | awk -F 'value=' '{print $2}' | awk '{print $1}')"
echo "\"$val\": ${key:-\"null\"}" >> huj
done
echo '}' >> huj

git config --global user.name "$1"
git config --global user.email "username@users.noreply.github.com"
git add huj
git commit -m "hz"
git push
