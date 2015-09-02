#!/bin/bash
if (( $# != 1)); then
        echo "Missing acq arg"
        exit
fi

acq=$1

curl --cookie cookieJar  http://palette-dev.pacegallery.com/palette/transaction/ajax/full?acquisitionId=$acq | python -m json.tool
