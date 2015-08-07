#!/bin/bash

curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/get/refine?sortType=SORT_TYPE_RELEVANCY_DESC | python -m json.tool
