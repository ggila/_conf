import os
import time
import pickle
from File.File import File

class Project:
    """
    """

    src = set()
    inc = set()
    incLocal = set()
    incSys = set()
    lastUpdate = time.time()

    def checkSource(self, rep):
        """
                travel through ./src/ and update attributes
        """
        for f in os.listdir(rep):
            if not os.path.isdir(rep + '/' + f) and f[0] != '.':
                s = 0
                if not f in self.src:
                    s = cFile(f)
                elif:
                    s = load(src)
                    if s.lastUpdate > self.lastUpdate
                        s

        for f in os.listdir(rep):
            if os.path.isdir(rep + '/' + f) and f[0] != '.':
                self.checkSource(rep + "/" + f)

    def update(self):
        """
                1 gather new state
                2 generate file
                3 write buffer
                4 some test (make, src/test...)
        """
        self.checkSrc(conf.src_dir)
        print "loc : ", self.incLocal
        print "sys : ", self.incSys
#        self.makeHeader()
#        self.makeMakefile()

    def initConfig(self):
        f = open('.project/')
        f.write()

    def __init__(self):
        self.inc_dir = './inc'
        self.src_dir = './src'
        print 'coucou'
#       import config
#        self.update()
        
P = Project()
