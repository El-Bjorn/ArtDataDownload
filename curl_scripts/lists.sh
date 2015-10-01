#!/bin/bash
if (( $# != 1)); then
        echo "Missing criteria arg"
        #exit
fi

criteria=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/list/listSearch?criteria=  | python -m json.tool
