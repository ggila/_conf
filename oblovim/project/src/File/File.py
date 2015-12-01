#!/usr/bin/python
# -*- coding: utf-8 -*-

import pickle

class File:

    name = ""
    path = ""
    typ = ""
    creator = ""
    lastUpdate = ""
    updator = ""

    def readFile(self):
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

    def __init__(self, name, path):
        self.name = name
        self.path = path
