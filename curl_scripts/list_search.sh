#!/bin/bash
#if (( $# != 1)); then
#        echo "Missing pgid arg"
#        exit
#fi

#pgid=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/list/listSearch?criteria= | python -m json.tool
