# har-jq-cheatsheet
Cheat sheet for extracting information from [HAR](https://en.wikipedia.org/wiki/.har) files using [JQ](https://stedolan.github.io/jq/).

HAR is "HTTP Archive" that contains detailed information about requests and responses.

To get HAR file: 
* Open Google Chrome Dev Tools on the page (F12)
* Go to "Network Tab"
* Right click -> Copy -> Copy all as HAR
* Paste into a new JSON fil.

* Listing all images with size and times
```jq
.log.entries[] | 
  {"url": .request.url, "time": .time, "size": .response.content.size} | 
  select(.url | match("png|jpg|PNG|JPG|jpeg|JPEG"))
```
* Count all images requests

```jq
[
  .log.entries[] | 
  select(.request.url | match("png|jpg|PNG|JPG|jpeg|JPEG"))
] | length
```
* Count total time for all loaded images *including* queueing
```jq
[
  .log.entries[] | 
  select(.request.url |
    match("png|jpg|PNG|JPG|jpeg|JPEG")
  ) | {time: .time}
] | reduce(.[]) as $i (0; . += $i.time)
```

* Count total time for all loaded images *without* queueing
```jq
[
  .log.entries[] |
  select(.request.url |
    match("png|jpg|PNG|JPG|jpeg|JPEG")
  ) | {time: .time, t: .timings} 
] | reduce(.[]) as $i (0; . += ($i.t.receive - $i.t._blocked_queueing + $i.t.send + $i.t.wait + $i.t.blocked))
```
* Count number of bytes transferred by images
```jq
[
  .log.entries[] |
  select(.request.url |
    match("png|jpg|PNG|JPG|jpeg|JPEG")
  ) | {r: .response} 
] | reduce(.[]) as $i (0; . += $i.r._transferSize)
```
