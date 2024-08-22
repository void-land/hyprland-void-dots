#! /usr/bin/env python3

import requests 
import json
import sys
import os
import subprocess
import shutil

imgdir = "/tmp/wallpapers"
eww_bin= [subprocess.getoutput("which eww"), "-c", f"{os.getcwd()}"]

try: 
    if sys.argv[1] == "search":
        if os.path.exists(imgdir):
            shutil.rmtree(imgdir)
            os.mkdir(imgdir)
        else: 
            os.mkdir(imgdir)

        data = json.loads(requests.get(f"https://wallhaven.cc/api/v1/search?q={'+'.join(sys.argv[2:])}&ratios=landscape").text)
        
        smaller = []
        count = 0
        for d in data["data"]: 

            if count == 15: 
                break
            count += 1

            img_data = requests.get(d["thumbs"]["small"]).content 
            with open(imgdir+"/"+d["id"]+".png", "wb") as f: 
                f.write(img_data)

            smaller.append({"path": imgdir+"/"+d["id"]+".png", "fav": d["favorites"], "views": d["views"], "url": d["path"]})

            subprocess.run(eww_bin+["update", f"wallpapers={json.dumps(smaller)}"])

        # print(json.dumps(smaller))
    elif sys.argv[1] == "select":
        url = sys.argv[2]

        if not url: 
            raise Exception("No url provided")  
        img_data = requests.get(url).content 
        with open(imgdir+"/selected.png", "wb") as f: 
            f.write(img_data)

        subprocess.run(["swaymsg", "output", "*", "bg", imgdir+"/selected.png", "fill"])
        
    elif sys.argv[1] == "reset": 
        subprocess.run(["swaymsg", "output", "*", "bg", os.path.expandvars("$HOME/.config/sway/wallpaper/tile.png"), "tile"])

except Exception as e: 
    print(e)
    print("{}")
