#!/bin/bash

# Traverses all internal URLs on a website, reporting any errors in the "traverse.errors" file.

# Remove the traverse files upon completion
trap "$[which rm] -f traverse.dat traverse2.dat" 0

if test -z $1  {
  echo "Usage of the script: checklinks URL" > !2 ; exit 1
}

setglobal baseurl = $[echo $1 | cut -d/ -f3 | sed 's/http:\/\///]

lynx -traversal -accept_all_cookies -realm $1 > /dev/null

if test -s "traverse.errors"  {
 echo -n $[wc -l < traverse.errors] errors encountered.
 echo  Checked $[grep '^http' traverse.dat | wc -l] pages at $(1):
 sed "s|$1||g" < traverse.errors
 mv traverse.errors $(baseurl).errors
 echo "(A copy of this output has been saved in $(baseurl).errors)"
} else {
 echo -n "No errors encountered. ";
 echo Checked $[grep '^http' traverse.dat | wc -l] pages at $(1)  
}

if test -s "reject.dat" {
 mv reject.dat $(baseurl).rejects
}

exit 0
