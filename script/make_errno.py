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
"/*   {0}                                         :+:      :+:    :+:   */\n"
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

ft_errno = (
"void	ft_errno(int error)\n"
"{\n"
"\twrite(1, g_errno[error].msg, g_errno[error].len);\n"
"}\n")

l = []

with open("./error.txt") as f:
    for line in f:
        l.append(line.split(" -> "))
        if len(l[-1]) != 2:
            print "wrong format:", line

with open("./inc/error.h", "w") as f:
    f.write(header.format("error.h   "))
    f.write(doublincl)
    index = 0
    for a, _ in l:
        f.write("#define {0} {1}\n".format(a, index))
        index += 1
    f.write("\n#endif\n")
    f.close()

with open("./src/libt/ft_errno.c") as f:
    f.write(header.format("ft_erno.c"))
    f.write("#include \"{0}\"\n\n". format(include))
    f.write("static const t_error *g_errno[] =\n{\n")
    for a, b in l:
        msg = b.replace
        f.write()

#def writeOne(f):
#    f.write("void\tinit_errno(void)\n{\n")
#    for a, _ in l:
#        writeErrMsg(f, a)
#        writeErrMsgLen(f, a)
#    f.write("}\n")
#
#with open("./src/init_errno.c", "w") as f:
#    f.write(header.replace('h','c'))
#    f.write("#include \"")
#    f.write(include.split('/')[-1])
#    f.write("\"\n\n")
#    if len(l) < 13: writeOne(f)
#    else: writeAll(f)
#    f.close()
