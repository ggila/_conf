import os
import re

header = (
"/* ************************************************************************** */\n"
"/*                                                                            */\n"
"/*                                                        :::      ::::::::   */\n"
"/*   proto.h                                            :+:      :+:    :+:   */\n"
"/*                                                    +:+ +:+         +:+     */\n"
"/*   By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+        */\n"
"/*                                                +#+#+#+#+#+   +#+           */\n"
"/*   Created: 2015/11/24 12:01:24 by ggilaber          #+#    #+#             */\n"
"/*   Updated: 2015/11/24 12:02:03 by ggilaber         ###   ########.fr       */\n"
"/*                                                                            */\n"
"/* ************************************************************************** */\n\n")

pattern = re.compile('\n\n([^\n]+)\n{\n')

tab = 0

def getProto(filename):
    global tab
    string = ""
    with open(filename, "r") as f:
        r = re.findall(pattern, f.read())
        if not r: return string
        for elem in r:
            if "static" not in elem:
                nb_tab = elem.count('\t')
                if nb_tab > tab: tab = nb_tab
            prot = re.sub("[\t]+", "@", elem)
            string += prot + ";\n"
    return string

def getDir(rep):
    string = ""
    string += "\n/*\n** " + rep[2:] + "\n*/\n\n"
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

proto = "#ifndef PROTO_H\n# define PROTO_H\n"
proto += getDir("./src")
proto += "\n#endif\n"

proto = re.sub("\nstatic[^\n]+","",proto)
proto = re.sub("\nint@main[^\n]+","",proto)
proto = re.sub("@","\t",proto)

with open("./inc/proto.h", "w") as f:
    f.write(header)
    f.write(proto)
f.close()
