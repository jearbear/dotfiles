#!/usr/bin/env python3

import json
import subprocess
from datetime import datetime
from html import escape
from itertools import chain

output = subprocess.check_output(
    [
        "khal",
        "list",
        "now",
        "4h",
        "--once",
        "--json",
        "title",
        "--json",
        "start",
        "--json",
        "end",
    ],
    text=True,
)

events = chain.from_iterable(map(json.loads, output.splitlines()))
event = next(events, None)

if event:
    now = datetime.now()
    start = datetime.strptime(event["start"], "%Y-%m-%d %I:%M %p")

    if start > now:
        target = start
        relation = "in"
    else:
        target = datetime.strptime(event["end"], "%Y-%m-%d %I:%M %p")
        relation = "for"

    total_minutes = max(0, int((target - now).total_seconds() // 60))
    hours, minutes = divmod(total_minutes, 60)
    duration = f"{hours}h {minutes}m" if hours else f"{minutes}m"
    text = (
        f'{escape(event["title"])} <span color="#f9e2af">{relation} {duration}</span>'
    )
else:
    text = ""

print(json.dumps({"text": text}))
