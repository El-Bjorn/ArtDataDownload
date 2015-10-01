#!/bin/bash
if (( $# != 1)); then
        echo "Missing acq arg"
        #exit
fi

acq=$1

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/search/acquisitions/facets?sortType=SORT_TYPE_RELEVANCY_DESC&refineArtistIds=155&refineArtistIds=94&refineAcquisitionStatusLabels=Sold&refineAcquisitionStatusLabels=Gifted 
