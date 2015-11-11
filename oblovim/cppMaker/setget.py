python << endPython
import vim

def upperfirst(x):
	return x[0].upper() + x[1:]

def getclassname(path):
	return path[1 + buf.rfind('/'):].split('.')[0]

def readArg(str):
	tab = str.split('\t')
	type = tab[1] + ' '
	name = tab[-1][:-1]

	if name[0] in "*&":
		while name[0] in "&*":
			type += name[0]
			name = name[1:]

	return type, name
endPython

function! SetGetter()
python << endPython

hpp = vim.current.buffer.name
cpp = hpp[:-3] + "cpp"

buf_list = [b.name for b in vim.buffers]
if not cpp in buf_list: exit

class_name = getclassname(hpp)
type, name = readArg(vim.current.line)

str = "{0}\t{1}::get{2}(void) const {{return this->{3};}}".format\
			(type, class_name, upperfirst(name[1:]), name)

b = [c for c in vim.buffers if c.name == buf][0]
b.append(str, 14)

endPython
endfunction

function! SetSetter()
python << endPython

hpp = vim.current.buffer.name
cpp = hpp[:-3] + "cpp"

buf_list = [b.name for b in vim.buffers]
if not cpp in buf_list: exit

class_name = getclassname(hpp)
type, name = readArg(vim.current.line)

str = "void\t{1}::set{2}({0}x) const {{this->{3} = x}}".format\
			(type, class_name, upperfirst(name[1:]), name)

b = [c for c in vim.buffers if c.name == buf][0]
b.append(str, 14)

endPython
endfunction
