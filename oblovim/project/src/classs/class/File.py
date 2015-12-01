#!/usr/bin/python
# -*- coding: utf-8 -*-

import pickle
import .project/config.py as conf

class File:

    name = ""
    di = ""
    path = ""
    typ = ""
    creator = ""
    last_update = ""
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
        pickle.dump(self, proj_dir + tickle)
        f.close()

    def __init__(self, name, path):
        self.name = name
        self.path = path
