#!/bin/bash

set -e

IN=$1
BASIC_SELECT=' .log.entries[] | select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) '

if [ ! -f ${IN} ]; then
    echo "Usage: har-stat <INPUT_FILE>"
    exit 1
fi

echo Processing HAR file ${IN}
LIST=$(jq "${BASIC_SELECT} | {url: .request.url, time: .time, size: .response.content.size, t: .timings}" ${IN})
COUNT=$(jq "[${BASIC_SELECT}] | length" ${IN})
TOTAL_TIME=$(jq "[ ${BASIC_SELECT} | {time: .time}] | reduce(.[]) as \$i (0; . += \$i.time)" ${IN})
BYTES=$(jq "[ ${BASIC_SELECT} | {r: .response} ] | reduce(.[]) as \$i (0; . += \$i.r._transferSize)" ${IN})

echo "${LIST}"
echo "Number of requests:       ${COUNT}"
echo "Total time with queueing: ${TOTAL_TIME}"
echo "Bytes:                    ${BYTES}"
