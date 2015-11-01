#!/bin/bash
if (( $# != 1)); then
        echo "Missing timestamp arg"
        #exit
fi


curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/artwork/changed_after?timestamp=Wed+Jun+30+2015+19%3A00%3A00+GMT-0500+%28EST%29
