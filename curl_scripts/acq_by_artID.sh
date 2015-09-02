#!/bin/bash
if (( $# != 1)); then
        echo "Missing pgid arg"
        exit
fi

pgid=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/acquisition/v2/findByArtworkId?artworkId=$pgid | python -m json.tool
