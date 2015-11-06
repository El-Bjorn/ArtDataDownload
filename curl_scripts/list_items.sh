#!/bin/bash
if (( $# != 1)); then
        echo "Missing list id arg"
        exit
fi


curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/list/listItems?id=$1 | python -m json.tool
