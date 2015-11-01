#!/bin/bash

/usr/bin/curl --cookie cookieJar http://palette-dev.pacegallery.com/palette/masterdata | python -m json.tool

