link="$(curl -fs https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/rss?path=/xiaomi.eu/Xiaomi.eu-app | awk '/link/ && /app/' | sed -n 1p | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')"			 
curl -vLo ./euapp.apk "$link"
[[ -f ./euapp.apk ]] && echo HUI
sudo apt install apktool -y                                                                                                                                                                                                   
apktool d --no-assets -fsbo ./euapp/ ./euapp.apk                                                                                                                                                                                        
                                                                                                                                                                                                                              
echo '{' > pif.json                                                                                                                                                                                                           
for val in PRODUCT DEVICE MANUFACTURER BRAND MODEL FINGERPRINT SECURITY_PATCH FIRST_API_LEVEL; do                                                                                                                             
    key="$(grep "$val" ./euapp.out/res/xml/inject_fields.xml | awk -F 'value=' '{print $2}' | awk '{print $1}')"                                                                                                                  
    echo "\"$val\": ${key:-\"null\"}" >> pif.json                                                                                                                                                                                 
done                                                                                                                                                                                                                          
echo '}' >> pif.json 

git config --global user.name 'github-actions'
git config --global user.email 'github-actions@github.com'
git add pif.json
git commit -m "hz"
git push
