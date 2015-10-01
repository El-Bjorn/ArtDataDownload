#!/bin/bash
if (( $# != 1)); then
        echo "Missing count arg"
        exit
fi

count=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/exhibition/ActivePending/full?index=0&count=$count 
