#!/bin/bash
if (( $# != 0)); then
        echo "Missing cri"
        exit
fi

acq=$1

curl --cookie cookieJar -d 'artists=478&sortType=SORT_TYPE_RELEVANCY_DESC' http://palette-dev.pacegallery.com/palette/search/acquisitions?count=1000&simple=true
