import 

patternFunc = re.compile('\n(?!static)([^\n]+)\n{\n')

class cFile(File):

    include = []
    func = []
    func_static = []

    def readCFile(self, text):
    """
            find include header with:
            re.compile('#include ([<"])([^">]+)[">]')
            add to self.inc sets
    """
        cFileInc = re.findall(includePattern, text)
        self.incLocal |= set([b for a, b in cFileInc if a == '"'])
        self.incSys |= set([b for a, b in cFileInc if a == '<'])
