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
# print(f"(box :valign 'fill' :vexpand true :orientation 'v' :space-evenly false (scroll :height 100 :width 300 :hscroll true :vscroll true (label :class 'quote' :text `\"{res['content']}\"` :wrap true :width 300)) (label :class 'quoteauthor' :text `- {res['author']}`))")
print(json.dumps(res))

