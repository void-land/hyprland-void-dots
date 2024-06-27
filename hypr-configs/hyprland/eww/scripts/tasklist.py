#!/usr/bin/env python3
from iconfetch import fetch
import subprocess
import json
import os 
import i3ipc

eww_bin= [subprocess.getoutput("which eww"), "-c", f"{os.getcwd()}"]

def recurse(apps, workspace, output): 
    for l in workspace.descendants(): 
        if not l.pid or not l.app_id:
            continue
        app_id = l.app_id.lower()

        if app_id == "com.github.xournalpp.xournalpp": 
            app_id = "xournalpp"

        rect = {
            "x": 0,
            "y": 0, 
            "width": 0,
            "height": 0
        }

        rect["x"] = l.rect.x - output.rect.x
        rect["y"] = l.rect.y - output.rect.y

        rect["width"] = l.rect.width * 1920/output.rect.width
        rect["height"] = l.rect.height * 1080/output.rect.height
        rect["x"] *= 1920/output.rect.width
        rect["y"] *= 1080/output.rect.height

        apps.append({
            "app_id": app_id,
            "name": l.name, 
            "pid": l.pid, 
            "focused": l.focused,
            "rect": rect,
            "path": fetch(app_id) or fetch("unknown")
        })

def update(i3, e): 

    root = i3.get_tree()

    apps = []
    windows = [[] for _ in range(10)]

    for output in root.nodes:
        if output.name == "__i3": 
            continue 

        for workspace in output.nodes: 
            found = []
            recurse(found, workspace, output)

            apps.extend(found)
            # if output["name"] == "eDP-1":
            #     windows[int(workspace["name"])-1] = found
            windows[int(workspace.name)-1] = found

    # change this yourself lol
    appsdict = {
        "firefox": [],
        "thunar": [], 
        "xournalpp": [], 
        "discord": [], 
        "foot": []
    }
    # translate to launch cmd
    appsexec = {
        "discord": "discord-wayland",
        "xournalpp": "com.github.xournalpp.xournalpp",
        "foot": "org.codeberg.dnkl.foot",
    }

    appsjson = []

    for app in apps: 
        a = app.copy()
        name = a["app_id"]

        if name not in appsdict: 
            appsdict[name] = []
        appsdict[name].append(a)

    for key, value in appsdict.items(): 
        if len(value) == 0: 
            appsjson.append(dict(
                path = fetch(key),
                name = key,
                app_id = key if key not in appsexec else appsexec[key], 
                pid = None, 
                focused = []
            ))

        else: 
            f = []
            for v in value: 
                f.append(v["focused"])

            appsjson.append(dict(
                path = value[0]["path"],
                name = value[0]["name"], 
                app_id = value[0]["app_id"].lower(), 
                pid = value[0]["pid"], 
                focused = f
            ))


    subprocess.run(eww_bin + ["update", f"windows={json.dumps(windows)}"])
    subprocess.run(eww_bin + ["update", f"tasksjson={json.dumps(appsjson)}"])

def main():
    i3 = i3ipc.Connection(auto_reconnect=True)
    update(i3, None)
    i3.on(i3ipc.Event.WINDOW, update)
    i3.main()
    

if __name__ == "__main__":
    main()
