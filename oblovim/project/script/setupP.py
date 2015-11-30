#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import re
import sys

if len(sys.argv) != 2:
    print "give me a name", 
    exit(0)

pName = sys.argv[1]

print pName

#├── .zshrc
#├── script
#│   ├── make_errno.py
#│   ├── tree.py
#|   ├── make_proto.py
#|   ├── patron.vim
#│   └── header.vim
#└── Makefile
#└── src
#|   └── main.c
#└── inc

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

    def addFile(self):
        os.system('cp -r ~/config/oblovim/project/script .')
        os.system('cp -r ~/config/oblovim/project/zshrc .zshrc')
        os.system('mkdir src')
        os.system('cp -r ~/config/oblovim/project/template/main.c src/')

    def __init__(self):
        self.name = pName
        self.addFile()
        


P = Project()
