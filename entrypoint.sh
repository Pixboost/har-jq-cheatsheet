#!/usr/bin/env bash

set -e

chromium-browser --remote-debugging-port=9222 --headless -no-sandbox --disable-gpu --window-size=1920,1080 &
chrome-har-capturer -o /har.json -g 20000 $1
/har-stat.sh ./har.json