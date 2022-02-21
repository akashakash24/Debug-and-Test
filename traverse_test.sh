trap "$(which rm) -f traverse.dat traverse2.dat" 0
if [ -z "$1" ] ; then
  echo "Usage: checklinks URL" >&2
  exit 1
fi
baseurl="$(echo $1 | cut -d/ -f3 | sed 's/http:\/\///')"
lynx -traversal -accept_all_cookies -realm "$1" > /dev/null
if [ -s "traverse.errors" ] ; then
  /bin/echo -n $(wc -l < traverse.errors) errors encountered.
  echo Checked $(grep '^http' traverse.dat | wc -l) pages at ${1}:
  sed "s|$1||g" < traverse.errors
  mv traverse.errors ${baseurl}.errors
  echo "A copy of this output has been saved in ${baseurl}.errors"
else
  /bin/echo -n "No errors encountered. ";
  echo Checked $(grep '^http' traverse.dat | wc -l) pages at ${1}
fi
if [ -s "reject.dat" ]; then
  mv reject.dat ${baseurl}.rejects
fi
exit 0


bash traverse_checklinks.sh http://www.404-error-page.com/
No errors encountered. Checked 1 pages at http://www.404-error-page.com/

bash traverse_checklinks.sh http://www.intuitive.com/library/
5 errors encountered. Checked 62 pages at http://intuitive.com/library/:
index/ in BeingEarnest.shtml
Archive/f8 in Archive/ArtofWriting.html
Archive/f11 in Archive/ArtofWriting.html
Archive/f16 in Archive/ArtofWriting.html
Archive/f18 in Archive/ArtofWriting.html
A copy of this output has been saved in intuitive.com.errors
