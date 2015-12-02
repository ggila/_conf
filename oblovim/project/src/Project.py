import os
import time
import pickle
from File.File import File

proj_dir = os.getcwd()
inc_dir = "./inc"
src_dir = "./src"

class Include:
    """
    Manage info about include:
    [['string.h', ['src/file1.c', 'src/file2.c']]]

    An include is anything matching (with re.M):
    '(?:^|\n)#include ([<"])([^">]+)[">]'
    """

    Usr = []
    Sys = []

    def checkInc(self, string):
        l = [[], []]
        pat = re.compile('(?:^|\n)#include ([<"])([^">]+)[">]', re.M)
        res = re.findall(pat, string)
        print res

    def addIn(self, name, l, fileName):
        flag = 1
        for inc, fileList in header if inc == name:
            flag = 0
            if not fileName in fileList: fileList.append(fileName)
        if flag:
            l.append([name, [fileName]])

    def add(self, name, status, fileName):
        if status == '"' : self.AddIn(name, Self.Usr, fileName)
        else : self.AddIn(name, self.Sys, fileName)

class Project:
    """
    """

    rename = 0

    src = set()
    inc = set()
    incUsr = set()
    incSys = set()
    lastUpdate = time.time()

    def checkFiles(self, proj_dir, func):
        """
                travel through ./src/ and update attributes
        """
        for f in os.listdir(self, rep, typ, func):
            if not os.path.isdir(rep + '/' + f) and f[0] != '.':
                s = 0
                if not f in self.src:
                    s = cFile(f)
                elif:
                    s = load(f)
                    if s.lastUpdate > self.lastUpdate: s.update()

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
        print "loc : ", self.incUsr
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
#       self.update()
        
P = Project()
