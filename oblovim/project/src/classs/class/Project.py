import configuration as conf

import pickle
import File

class Project:
    """
    - pwd
    - listfile
    - src

    - self.name = pName
    - self.src = []
    - self.inc = []
    """

    inc_dir = "./inc"
    src_dir = "./src"
    proj_dir = os.getcwd()

    self.src = set()
    self.incLocal = set()
    self.incSys = set()

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

    def update(self):
        """
                1 gather new state
                2 generate file
                3 write buffer
                4 some test (make, src/test...)
        """
        self.incLocal = set()
        self.incSys = set()
        self.checkSource(conf.src_dir)
        print "loc : ", self.incLocal
        print "sys : ", self.incSys
        self.makeHeader()
#        self.makeMakefile()

    def __init__(self):
#       import config
        os.system('cp -r ~/config/oblovim/project/.project .')
        os.system('mkdir ' + .self.inc)
        os.system('mkdir' + self.src)
        os.system('touch inc/' + self.name + '.h')
        os.system('cp -r ~/config/oblovim/project/template/main.c' + conf.src_dir)
        with open(".project/config.py", "w+")
        self.update()
        
P = Project()
