#!/bin/bash
if (( $# != 1)); then
	echo "missing acq num"
	exit
fi

curl -v --cookie cookieJar http://palette-dev.pacegallery.com/palette/reserve/all/$1 | python -m json.tool
