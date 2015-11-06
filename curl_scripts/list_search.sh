#!/bin/bash
if (( $# != 1)); then
        echo "Missing list search criteria arg"
        #exit
fi


curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/list/listSearch?criteria=$1 | python -m json.tool
