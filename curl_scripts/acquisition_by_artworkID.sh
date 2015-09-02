#!/bin/bash
if (( $# != 1)); then
	echo "missing artwork id"
	exit
fi

curl -v --cookie cookieJar http://palette-dev.pacegallery.com/palette/acquisition/v2/findByArtworkId?artworkId=$1 | python -m json.tool
