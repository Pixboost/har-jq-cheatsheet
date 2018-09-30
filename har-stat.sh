#!/bin/bash

set -e

IN=$1

if [ ! -f ${IN} ]; then
    echo "Usage: har-stat <INPUT_FILE>"
    exit 1
fi

echo Processing HAR file ${IN}

ALL_IMAGES=$(jq '.log.entries[] |select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) | "\(.request.url) \(.response._transferSize)"' ${IN})
echo "IMAGES:          ${ALL_IMAGES}"

ON_CONTENT_LOAD=$(jq '.log.pages[0].pageTimings.onContentLoad' ${IN})
ON_LOAD=$(jq '.log.pages[0].pageTimings.onLoad' ${IN})
COUNT=$(jq '[ .log.entries[] | select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) ] | length' ${IN})
TOTAL_TIME=$(jq '[.log.entries[] | select(.request.url |  match("png|jpg|PNG|JPG|jpeg|JPEG")) | {time: .time}] | reduce(.[]) as $i (0; . += $i.time)' ${IN})
REQ_TIME=$(jq '[.log.entries[] |select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) | {time: .time, t: .timings} ] | reduce(.[]) as $i (0; . += ($i.t.receive - $i.t._blocked_queueing + $i.t.send + $i.t.wait + $i.t.blocked))' ${IN})
BYTES=$(jq '[.log.entries[] |select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) | {r: .response} ] | reduce(.[]) as $i (0; . += $i.r._transferSize)' ${IN})

echo "On content load:          ${ON_CONTENT_LOAD}"
echo "On load:                  ${ON_LOAD}"
echo "Number of requests:       ${COUNT}"
echo "Total time with queueing: ${TOTAL_TIME}"
echo "Requests time:            ${REQ_TIME}"
echo "Bytes:                    ${BYTES}"
