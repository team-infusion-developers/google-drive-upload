#!/bin/bash

## uploading to google
## rev: 22 Aug 2012 16:07

det=`date +%F`
browser="Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:13.0) Gecko/20100101 Firefox/13.0.1"
username="user@domain-apps.com"
password="password"
accountype="HOSTED" #gooApps = HOSTED , gmail=GOOGLE
pewede="/tmp"
file="file-$det.tar"
tipe="application/x-tar"

/usr/bin/curl -v --data-urlencode Email=$username --data-urlencode Passwd=$password -d accountType=$accountype -d service=writely -d source=cURL "https://www.google.com/accounts/ClientLogin" > $pewede/login.txt

token=`cat $pewede/login.txt | grep Auth | cut -d \= -f 2`


uploadlink=`/usr/bin/curl -Sv -k --request POST  -H "Content-Length: 0" -H "Authorization: GoogleLogin auth=${token}" -H "GData-Version: 3.0" -H "Content-Type: $tipe" -H "Slug: $file" "https://docs.google.com/feeds/upload/create-session/default/private/full?convert=false" -D /dev/stdout | grep "Location:" | sed s/"Location: "//`

/usr/bin/curl -Sv -k --request POST --data-binary "@$file" -H "Authorization: GoogleLogin auth=${token}" -H "GData-Version: 3.0" -H "Content-Type: $tipe" -H "Slug: $file" "$uploadlink" > $pewede/goolog.upload.txt
