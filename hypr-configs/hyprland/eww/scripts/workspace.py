#!/usr/bin/env python3

import subprocess
import json
import os
import i3ipc

eww_bin= [subprocess.getoutput("which eww"), "-c", f"{os.getcwd()}"]

def get_workspaces(i3):
    result = i3.get_workspaces()

    active = []

    for i in range(1, 6): 
        active.append(dict(
            focused = False,
            empty = True, 
            name = i
        ))

    for res in result:
        if not res.output == "eDP-1": continue
        if res.num%10-1 > 4 or res.num%10-1 < 0:
            continue
        active[res.num%10-1]["empty"] = False
        if res.focused:
            active[res.num%10-1]["focused"] = True

    return active

def update(i3, e):
    print(json.dumps(get_workspaces(i3)), flush=True)

def main():
    i3 = i3ipc.Connection(auto_reconnect=True)
    update(i3, None)
    i3.on(i3ipc.Event.WORKSPACE, update)
    i3.main()

if __name__ == "__main__":
    main()
