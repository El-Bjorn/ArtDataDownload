#!/bin/bash
if (( $# != 1)); then
        echo "Missing search arg"
        exit
fi

search_arg=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/quicksearch?term=$search_arg | python -m json.tool
