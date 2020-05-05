#!/usr/bin/env bash
set -euo pipefail

username=$(bw get username Feedbin --session $BW_SESSION)
password=$(bw get password Feedbin --session $BW_SESSION)

curl -s --request POST \
    --user "$username:$password" \
    --header "Content-Type: application/json; charset=utf-8" \
    --data-ascii "{\"url\": \"${1:?Must provide a URL to send to Feedbin.}\"}" \
    -w "%{http_code}\n" \
    -o /dev/null \
    https://api.feedbin.com/v2/pages.json
