import os
import re

pattern = re.compile('\n\n([^\n]+)\n{\n')

def getProto(filename):
    string = ""
    with open(filename, "r") as f:
        string += "// " + filename[6:] + "\n"
        r = re.findall(pattern, f.read())
        if not r: return string
        for elem in r:
            if not elem[:7] == "static ":
                string += elem + ";\n"
    return string + "\n"

def getDir(rep):
    string = ""
    for f in os.listdir(rep):
        if not os.path.isdir(rep + "/" + f) and f[0] != '.':
            string += getProto(rep + "/" + f)
    for f in os.listdir(rep):
        if os.path.isdir(rep + "/" + f) and f[0] != '.':
            string += getDir(rep + "/" + f)
    return string

if not (os.path.exists("./src")):
    print "please change dir"
    exit(0)

proto = "#ifndef PROTO_H\n# define PROTO_H\n\n"
proto += getDir("./src")
proto += "#endif\n"


with open("./inc/proto.h", "w") as f:
    f.write(proto)

f.close()
