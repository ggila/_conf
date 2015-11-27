import os
import re
import sys

if len(sys.argv) != 2:
    print "give me an header to edit", 
    exit(0)

include = sys.argv[1]

check = ["./inc", "./src", "./error.txt"]
error = []

for elem in check:
    if not (os.path.exists(elem)): error.append(elem)

if len(error):
    for e in error:
        print e, "is not there"
    exit(0)

header = (
"/* ************************************************************************** */\n"
"/*                                                                            */\n"
"/*                                                        :::      ::::::::   */\n"
"/*   error.h                                            :+:      :+:    :+:   */\n"
"/*                                                    +:+ +:+         +:+     */\n"
"/*   By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+        */\n"
"/*                                                +#+#+#+#+#+   +#+           */\n"
"/*   Created: 2015/11/24 12:01:24 by ggilaber          #+#    #+#             */\n"
"/*   Updated: 2015/11/24 12:02:03 by ggilaber         ###   ########.fr       */\n"
"/*                                                                            */\n"
"/* ************************************************************************** */\n"
"\n")

doublincl = (
"#ifndef ERROR_H\n"
"# define ERROR_H\n"
"\n")

l = []

with open("./error.txt") as f:
    for line in f:
        l.append(line.split(" -> "))
        if len(l[-1]) != 2:
            print "wrong format:", line

def writeIndex(f, a, index):
    f.write("# define ")
    f.write(a)
    f.write(" ")
    f.write(str(index))
    f.write("\n")

def writeMsg(f, a, b):
    f.write("# define ")
    f.write(a)
    f.write("_MSG \"")
    f.write(b[:-1])
    f.write("\"\n")

def writeLen(f, a, b):
    f.write("# define ")
    f.write(a)
    f.write("_LEN ")
    f.write(str(len(b)))
    f.write("\n\n")

with open("./inc/error.h", "w") as f:
    f.write(header)
    f.write(doublincl)
    index = 0
    for a, b in l:
        writeIndex(f, a, index)
        writeMsg(f, a, b)
        writeLen(f, a, b)
        index += 1
    f.write("#endif\n")
    f.close()

def writeErrMsg(f, a):
   f.write("\tg_errno[")
   f.write(a)
   f.write("].msg = ")
   f.write(a)
   f.write("_MSG;\n")

def writeErrMsgLen(f, a):
   f.write("\tg_errno[")
   f.write(a)
   f.write("].len = ")
   f.write(a)
   f.write("_LEN;\n")

def writeAll(f):
    index = 0
    for a, _ in l:
        if index % 12 == 0:
            f.write("static void\tinit_errno_")
            f.write(str(index / 12 + 1))
            f.write("(void)\n{\n")
        writeErrMsg(f, a)
        writeErrMsgLen(f, a)
        index += 1
        if index % 12 == 0:
            f.write("}\n\n")
    if index % 12 != 0:
        f.write("}\n\n")
    f.write("void\t\tinit_errno(void)\n{\n")
    for i in range((len(l) - 1) /12 + 1):
        f.write("\tinit_errno_")
        f.write(str(i + 1))
        f.write("();\n")
    f.write("}\n")

def writeOne(f):
    f.write("void\tinit_errno(void)\n{\n")
    for a, _ in l:
        writeErrMsg(f, a)
        writeErrMsgLen(f, a)
    f.write("}\n")

with open("./src/init_errno.c", "w") as f:
    f.write(header.replace('h','c'))
    f.write("#include \"")
    f.write(include.split('/')[-1])
    f.write("\"\n\n")
    if len(l) < 13: writeOne(f)
    else: writeAll(f)
    f.close()
