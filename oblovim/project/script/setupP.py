#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import re
import sys

if len(sys.argv) != 2:
    print "give me a name", 
    exit(0)

pName = sys.argv[1]
includePattern = re.compile('\n#include [<"]([^">]+)[">]\n')

print pName

#├── script
#│   ├── make_errno.py
#│   ├── tree.py
#|   ├── make_proto.py
#|   ├── patron.vim
#│   └── header.vim
#└── src
#|   └── main.c
#└── inc
#|   └── $(pName).h

class File:
    """
    - type (src, obj,...)
    - content
    """


class Project:
    """
    - pwd
    - listfile
    - src
    """



#    def setUpDir(self):
#        os.system('cp -r  ~/config/oblovim/project/template/newP .')

    def checkInclude(self, l):
        for e in l: print e

    def readCFile(self, path):
        with open(path, 'r') as f:
            text = "\n{0}".format(f.read())
            self.checkInclude(re.findall(includePattern, text))

    def checkSource(self, rep):
        for f in os.listdir(rep):
            if not os.path.isdir(rep + '/' + f) and f[0] != '.' and f[-2:] == '.c':
                self.readCFile(rep + "/" + f)
        for f in os.listdir(rep):
            if os.path.isdir(rep + '/' + f) and f[0] != '.':
                self.checkSource(rep + "/" + f)

    def Update(self):
        self.checkSource('./src')
#        self.makeHeader()
#        self.makeMakefile()

    def __init__(self):
        self.name = pName
        self.src = []
        self.inc = []
        os.system('cp -r ~/config/oblovim/project/script .')
        os.system('mkdir src')
        os.system('cp -r ~/config/oblovim/project/template/main.c src/')
        self.Update()
        


P = Project()
