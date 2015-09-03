#!/bin/bash
if (( $# != 1)); then
        echo "Missing art id arg"
        exit
fi

artid=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/acquisition/v2/findByArtworkId?artworkId=$artid | python -m json.tool
