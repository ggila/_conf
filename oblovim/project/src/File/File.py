#!/usr/bin/python
# -*- coding: utf-8 -*-

import pickle

class File:

    rename = 0

    name = ""
    path = ""
    typ = ""
    creator = ""
    lastUpdate = ""
    updator = ""

    def readFile(eelf):
        f.open(self.path, "r")
        content = f.read()
        f.close()
        return content

    def writeFile(self, content):
        f.open(self.path, "w")
        f.write(content)
        f.close()

    def save(self):
        f.open(self.path, "wb")
        pickle.dump(self, '.project/' + name)
        f.close()

    def checkHeader(self, name):
        with open(name, 'r') as f:
            head = [next(f) for f in range(13)]
            for t


    def __init__(self, name, path):
        self.name = name
        self.path = name(:name.rfind('/'))
        self.typ = re.match('.*\.(.*)', name).group(1)
        creator, lastUpdate, updator = self.checkHeader(name)
