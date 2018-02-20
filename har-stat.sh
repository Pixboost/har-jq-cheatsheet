#!/bin/bash

IN=$1

echo Processing HAR file ${IN}

COUNT=$(jq '[ .log.entries[] | select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) ] | length' ${IN})
TOTAL_TIME=$(jq '[.log.entries[] | select(.request.url |  match("png|jpg|PNG|JPG|jpeg|JPEG")) | {time: .time}] | reduce(.[]) as $i (0; . += $i.time)' ${IN})
REQ_TIME=$(jq '[.log.entries[] |select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) | {time: .time, t: .timings} ] | reduce(.[]) as $i (0; . += ($i.t.receive - $i.t._blocked_queueing + $i.t.send + $i.t.wait + $i.t.blocked))' ${IN})
BYTES=$(jq '[.log.entries[] |select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG")) | {r: .response} ] | reduce(.[]) as $i (0; . += $i.r._transferSize)' ${IN})

echo "Number of requests:       ${COUNT}"
echo "Total time with queueing: ${TOTAL_TIME}"
echo "Requests time:            ${REQ_TIME}"
echo "Bytes:                    ${BYTES}"
