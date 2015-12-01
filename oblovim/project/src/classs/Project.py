import pickle
import Header
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

    def initConfig(self):
        f = open('.project/')
        f.write()

    def __init__(self):
#       import config
        self.update()
        
P = Project()
