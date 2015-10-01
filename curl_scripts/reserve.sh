#!/bin/bash
if (( $# != 1)); then
        echo "Missing acq arg"
        #exit
fi

acq=$1

curl --cookie cookieJar -H "Content-Type: application/json" --data "{\"price\":\"175000.00\",\"currency\":\"USD\",\"confidentialClient\":true,\"acquisitionId\":31657,\"paceContactId\":\"39\",\"client\":{\"id\":\"19516\"}}" http://palette-dev.pacegallery.com/palette/reserve 
