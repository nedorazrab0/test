MODDIR=${0%/*}
get_json(){
    curl -fs 'https://raw.githubusercontent.com/nedorazrab0/test/main/pif.json' "$@"
}

until ping -c 1 google.com; do
    sleep 1
done

while true; do
    until get_json; do
        sleep 10
    done

    get_json -o "$MODDIR/pif.json"
    cp -f "$MODDIR/pif.json" /data/adb/
    pkill -f com.google.android.gms
    sleep 43200
done
