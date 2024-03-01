#!/usr/bin/env python

import glob
import sys
import os
import json
import subprocess
import gi

gi.require_version("Gtk", "3.0")

from gi.repository import Gtk
from configparser import ConfigParser

cache_file = os.path.expandvars("$XDG_CACHE_HOME/apps.json")

def get_gtk_icon(icon_name):
    theme = Gtk.IconTheme.get_default()
    icon_info = theme.lookup_icon(icon_name, 128, 0)

    if icon_info is not None:
        return icon_info.get_filename()

def get_desktop_entries(query=None):
    desktop_files = glob.glob(os.path.join("/usr/share/applications", "*.desktop"))
    entries = []

    for file_path in desktop_files:
        parser = ConfigParser()
        parser.read(file_path)

        if parser.getboolean("Desktop Entry", "NoDisplay", fallback=False):
            continue  # Skip entries with NoDisplay=true

        app_name = parser.get("Desktop Entry", "Name")
        icon_path = get_gtk_icon(parser.get("Desktop Entry", "Icon", fallback=""))
        comment = parser.get("Desktop Entry", "Comment", fallback="")

        entry = {
                "name": app_name,
                "icon": icon_path,
                "comment": comment,
                "desktop": os.path.basename(file_path),
            }
        entries.append(entry)
    return entries

def update_cache(entries):
    with open(cache_file, "w") as file:
        file.write(json.dumps(entries, indent=2))
        
def get_cached_entries():
    if os.path.exists(cache_file):
        with open(cache_file, "r") as file:
            content = file.read().strip()
            if content:
                try:
                    return json.loads(content)
                except json.JSONDecodeError:
                    pass

    entries = get_desktop_entries()
    update_cache(entries)
    return entries

def filter_entries(entries, query):
    filtered_data = [
        entry for entry in entries
        if query.lower() in entry["name"].lower()
        or (entry["comment"] and query.lower() in entry["comment"].lower())
    ]
    return filtered_data

def update_eww(entries):
    update = ["eww", "update", "apps={}".format(json.dumps(entries))]
    subprocess.run(update)

if __name__ == "__main__":
    if len(sys.argv) > 2 and sys.argv[1] == "--query":
        query = sys.argv[2]
    else:
        query = None

    entries = get_cached_entries()

    if query is not None:
        filtered = filter_entries(entries, query)
        update_eww(filtered)
    else:
        update_eww(entries)