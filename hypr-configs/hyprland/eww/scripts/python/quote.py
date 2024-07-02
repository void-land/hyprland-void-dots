#!/usr/bin/python3
import requests
import json

try:
    req = requests.get("https://api.quotable.io/random").text
    res = json.loads(req)
except:
    res = {
            "content": "I can't get quotes, you are not online right now",
            "author": "quote widget"
    }
print(json.dumps(res))

