#!/usr/bin/env python3

from sys import argv
from json import dumps

def main():
    items = ["version", "versionCode",
             "zipUrl", "changelog"]
    info = {}
    i = 0
    for item in items:
        i = i + 1
        info[item] = argv[i]

    with open("update.json", "w") as json:
        json.write(dumps(info, indent=4))

if __name__ == "__main__":
    main()
