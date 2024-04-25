while true; do
    until ping -qns1 -c1 github.com; do
        sleep 1
    done

    curl -fso /data/adb/pif.json 'https://raw.githubusercontent.com/nedorazrab0/test/main/pif.json'
    pkill -f com.google.android.gms
    sleep 43200
done
