#!/bin/bash
if (( $# != 1)); then
	echo "missing pgid"
	exit
fi

curl -v --cookie cookieJar http://palette-dev.pacegallery.com/palette/artwork/image/id?pgNumber=$1&width=50 &> /dev/null
