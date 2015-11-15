python << endPython
import vim

def splitPathname(pathname):
    sep = pathname.rfind('/')
    return pathname[:sep + 1], pathname[1 + sep:]

pathname = vim.current.buffer.name

path, name = splitPathname(pathname)
filelist = name.split('.')
cName = filelist[0]
fileType = filelist[-1]

# Variable: (Dict)
#   type
#   name
#   const
#   :wqa

class classs:
    """ Attribut:
           - name
           - nested class
           - attribut
           - methods
    """

    def __init__(self, name):
        self.name = cName

    def setClass(self):
        if fileType == 'cpp':setClassFromCPP()
        else:setClassFromHPP()

endPython
