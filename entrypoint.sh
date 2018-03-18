#!/usr/bin/env bash

set -e

chromium-browser --remote-debugging-port=9222 --headless -no-sandbox --disable-gpu &
chrome-har-capturer -o /har.json -x 1280 -y 1280 -g 20000 $1
/har-stat.sh ./har.json