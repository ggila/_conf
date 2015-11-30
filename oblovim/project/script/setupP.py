#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import re
import sys

if len(sys.argv) != 2:
    print "give me a name", 
    exit(0)

pName = sys.argv[1]
includePattern = re.compile('#include ([<"])([^">]+)[">]')

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
    - self.name = pName
    - self.src = []
    - self.inc = []
    """



#    def setUpDir(self):
#        os.system('cp -r  ~/config/oblovim/project/template/newP .')

    def readCFile(self, path):
        """
                find include header with:
                re.compile('#include ([<"])([^">]+)[">]')
                add to self.inc sets
        """
        with open(path, 'r') as f:
            text = "\n{0}".format(f.read())
            cFileInc = re.findall(includePattern, text)
            self.incLocal |= set([b for a, b in cFileInc if a == '"'])
            self.incSys |= set([b for a, b in cFileInc if a == '<'])


    def checkSource(self, rep):
        """
                travel through ./src/ and update attributes
        """
        for f in os.listdir(rep):
            if not os.path.isdir(rep + '/' + f) and f[0] != '.' and f[-2:] == '.c':
                self.readCFile(rep + "/" + f)
        for f in os.listdir(rep):
            if os.path.isdir(rep + '/' + f) and f[0] != '.':
                self.checkSource(rep + "/" + f)

    def makeHeader(self):
        """
                generate project header
        """
        with open("./inc/" + self.name + ".h", "w") as f:
            f.write("#ifndef {0}_H\n".format(self.pName.upper())
            f.write("# define {0}_H\n\n".format(self.pName.upper()))
            for elem in this.incSys:
                f.write('#include <{0}>\n'.format(elem))
            f.write("\n")
            for elem in this.incLocal:
                f.write('#include <{0}>\n'.format(elem))
            f.write("\n#endif\n")

    def update(self):
        """
                1 gather new state
                2 generate file
                3 write buffer
                4 some test (make, src/test...)
        """
        self.incLocal = set()
        self.incSys = set()
        self.checkSource('./src')
        print "loc : ", self.incLocal
        print "sys : ", self.incSys
        self.makeHeader()
#        self.makeMakefile()

    def __init__(self):
        self.name = pName
        self.src = []
        self.incLocal = set()
        self.incSys = set()
        os.system('cp -r ~/config/oblovim/project/script .')
        os.system('mkdir src')
        os.system('mkdir inc')
        os.system('touch inc/' + self.name + '.h')
        os.system('cp -r ~/config/oblovim/project/template/main.c src/')
        self.update()
        


P = Project()
