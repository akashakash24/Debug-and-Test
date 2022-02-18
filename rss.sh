RSS_URL="https://www.feedforall.com/sample.xml"


curl --silent "$RSS_URL" | grep -E '(title>|description>)' | tail -n +4 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/  /' -e 's/<\/description>//'
