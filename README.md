# har-jq-cheatsheet
Cheat sheet for extracting information from HAR files using JQ

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
  select(.request.url | 
  match("png|jpg|PNG|JPG|jpeg|JPEG"))
] | length
```
* Count total time of all loaded images
```jq
[
  .log.entries[] | 
  select(.request.url |
  match("png|jpg|PNG|JPG|jpeg|JPEG")) | 
  {time: .time}
] | reduce(.[]) as $i (0; . += $i.time)
```
