#RSSI Monitoring script
[ -z "$1" -o -z "$2" -o -n "$3" ] && {
  echo "Usage: $0 <wdev> <ssid>"
  exit 1
}
wdev="$1"
ssid="$2"

# Check if the device exists or not
iw dev "$wdev" info >/dev/null || exit 2


cleanup() {

  echo -en '\e[?25h'
}

trap 'cleanup; trap - INT; kill -s INT "$$"' INT
trap 'cleanup' EXIT


echo -en '\e[?25l'

get_ssid_info() {
  local args
  [ -n "$freq" ] && args="freq $freq"
  iw dev "$wdev" scan $args | grep 'freq:\|signal:\|SSID:' | grep -B2 "SSID: $ssid"
}

get_field() {
  grep "$1:" | cut -f 2 | cut -d ' ' -f 2
}


echo -n "Locking on '$ssid'... "
ssid_info=$(get_ssid_info)
[ "$?" -ne 0 ] && {
  echo ""
  echo "SSID '$ssid' not found"
  exit 2
}
echo "done"
freq=$(echo "$ssid_info" | get_field 'freq')

while true; do
  sig=$(get_ssid_info | get_field 'signal')
  echo -ne "$sig\r"
  sleep 1
done
