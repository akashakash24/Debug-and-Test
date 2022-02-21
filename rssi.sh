# SPDX-FileCopyrightText: 2019 Kirill Elagin <https://kir.elagin.me/>
# SPDX-License-Identifier: MPL-2.0

###
#
# Monitor signal strength (RSSI) of a Wi-Fi network on Linux.
#
# Given an SSID, the script outputs the signal strength of the
# corresponding access point every second. On the first scan it
# remembers the frequence of the SSID to be able to rescan rapidly.
#
# This script was tested on an OpenWRT router, but should work
# on any wireless-capable Linux machine. The dependencies are:
#
#   * POSIX shell (tested with Busybox ash)
#   * standard Unix tools or shell builtins: cut, echo, grep, head, true, sleep
#   * iw
#
#
# Usage:
#   rssi.sh <wdev> <SSID>
#
# Use `iw dev` to find a suitable wireless device to pass as `wdev` (it will
# probably be something like `wlan0`, at least on OpenWRT).
#
#
# https://gist.github.com/kirelagin/a3e6f0114dafbff912616b3bcc70c8b3
###

[ -z "$1" -o -z "$2" -o -n "$3" ] && {
  echo "Usage: $0 <wdev> <ssid>"
  exit 1
}
wdev="$1"
ssid="$2"

# Check the device exists
iw dev "$wdev" info >/dev/null || exit 2


cleanup() {
  # Show cursor
  echo -en '\e[?25h'
}
trap 'cleanup; trap - INT; kill -s INT "$$"' INT
trap 'cleanup' EXIT

# Hide cursor
echo -en '\e[?25l'

get_ssid_info() {
  local args
  # Only scan a specific frequency, if given, to speed up
  [ -n "$freq" ] && args="freq $freq"
  iw dev "$wdev" scan $args | grep 'freq:\|signal:\|SSID:' | grep -B2 "SSID: $ssid"
}

get_field() {
  grep "$1:" | cut -f 2 | cut -d ' ' -f 2
}

# Get the frequency of the SSID
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
