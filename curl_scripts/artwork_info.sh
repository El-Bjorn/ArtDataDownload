#!/bin/bash
if (( $# != 1)); then
        echo "Missing artworkID arg"
        exit
fi


curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/artwork/$1
