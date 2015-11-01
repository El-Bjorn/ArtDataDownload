#!/bin/bash
if (( $# != 1)); then
        echo "Missing search arg"
        exit
fi

search=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/search/cms_emb?term=$search | python -m json.tool
