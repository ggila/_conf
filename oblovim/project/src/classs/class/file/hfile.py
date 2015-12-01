import 

class hFile(File):

    define = []
    incUsr = []
    incSys = []
    struct = []
    proto = []

    def writeHFile(self):
        cFileInc = re.findall(includePattern, text)
        self.incLocal |= set([b for a, b in cFileInc if a == '"'])
        self.incSys |= set([b for a, b in cFileInc if a == '<'])

    def makeHeader(self):
    """
            generate project header
    """
    with open(proj_dir + inc_dir + self.name, "w") as f:
        f.write("#ifndef {0}_H\n".format(self.name.upper()))
        f.write("# define {0}_H\n\n".format(self.name.upper()))
        for elem in P.incSys:
            f.write('#include <{0}>\n'.format(elem))
        f.write("\n")
        for elem in P.self.incLocal:
            f.write('#include "{0}"\n'.format(elem))
        f.write("\n#endif\n")
