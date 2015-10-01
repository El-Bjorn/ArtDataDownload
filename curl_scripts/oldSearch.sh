#!/bin/bash
if (( $# != 1)); then
        echo "Missing cri"
        exit
fi

acq=$1

#curl --cookie cookieJar  http://palette-dev.pacegallery.com/palette/search/acquisitions?criteria=$crit | python -m json.tool
#curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/search?criteria={"artists":[{"id":122,"label":"Chuck Close"}],"sortType":"SORT_TYPE_RELEVANCY_DESC"}
#curl --get --cookie cookieJar http://palette-dev.pacegallery.com/palette/search --data-urlencode 'criteria={"artworkPgNumber":"31295","sortType":"SORT_TYPE_RELEVANCY_DESC"}'
#curl --cookie cookieJar --data-urlencode 'criteria={"artworkPgNumber":"31295","sortType":"SORT_TYPE_RELEVANCY_DESC"}' http://palette-dev.pacegallery.com/palette/search/acquisitions
curl --cookie cookieJar --data-urlencode 'criteria={"artists":[{"id":122,"label":"Chuck Close"}],"sortType":"SORT_TYPE_RELEVANCY_DESC"}' http://palette-dev.pacegallery.com/palette/search/acquisitions?count=3&simple=true
#curl --cookie cookieJar --get --data 'count=10&simple=true' http://palette-dev.pacegallery.com/palette/search/acquisitions
#curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/search/acquisitions?count=10&simple=true
