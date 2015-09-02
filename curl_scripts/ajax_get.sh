#!/bin/bash
if (( $# != 1)); then
        echo "Missing index arg"
        exit
fi


curl --data "index=$1&sortType=SORT_TYPE_RELEVANCY_DESC" -s --cookie cookieJar http://palette-dev.pacegallery.com/palette/search/filter/ajax/get | python -m json.tool #| grep artworkPgNumber | awk -F ':' '{print $2}' | sed 's/"//g' | sed 's/,//'
