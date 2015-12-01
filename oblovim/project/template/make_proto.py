import os
#!/usr/bin/python

import re
from subprocess import call

if not (os.path.exists("./src")):
    print "please change dir"
    exit(0)

pattern = re.compile('\n\n([^\n]+)\n{\n')

func = []

def handleProto(elem, rep):
    global func
    if "static" in elem: return
    if "\tmain" in elem: return
    l = elem.split('\t')
    l = [elem for elem in l if len(elem)]
    if len(l) != 2:
        print elem, "in", rep
        print "should be \'type[\\t]+func_name()\'"
        return
    func.append([l[0], l[1], rep])


def getProto(filename, rep):
    global func
    with open(filename, "r") as f:
        r = re.findall(pattern, f.read())
        if not r: return
        for elem in r: handleProto(elem, rep)

def getDir(rep):
    global func
    for f in os.listdir(rep):
        if not os.path.isdir(rep + "/" + f) and f[0] != '.':
            getProto(rep + "/" + f, rep[2:])
    for f in os.listdir(rep):
        if os.path.isdir(rep + "/" + f) and f[0] != '.':
            getDir(rep + "/" + f)

def countTab(string):
    global m
    nb_tab = (m - 1) / 4 + 1
    return nb_tab - len(string) / 4

getDir("./src")
l = [a for a, _, _ in func]

m = max(map(len, l))

def printProto(f):
    global func
    cur_dir = ""
    for t, r, d in func:
        if d != cur_dir:
            f.write("\n/*\n** ")
            f.write(d)
            f.write("\n*/\n\n")
            cur_dir = d
        f.write(t)
        f.write('\t' * countTab(t))
        f.write(r)
        f.write(";\n")

with open("./inc/proto.h", "w") as f:
    f.write(header)
    f.write("#ifndef PROTO_H\n# define PROTO_H\n")
    printProto(f)
    f.write("\n#endif\n")
f.close()

call(["norminette", "inc/proto.h"])
