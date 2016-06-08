# Scan through dir and setup README.md

def readReadme(root):
    ''' if a README.md is met during os.walk(), this function is
        used to get its description (4th line and followings ones)
    '''
    with open(root + 'README') as f:
        i = 0
        ret = 
        for line in f:
            if i == 4:
                ret += line
                if line == '\n': return readme
            else: i += 1
        return readme

def checkPyFile(source):
    ''' open source file and return its description
    '''
    with open(source) as f:
        if source[-3:] == '.py':
            if f.readline() != '# ggila\n': return '\n'
            ret = ''
            while True:
                s = f.readline()
                if s[0] != '#': return ret
                ret += s[2:]
#        else:


for root, dirs, files in os.walk('.', topdown = False):
    if '.git' not in root:
        readme = '# {}\n\n'.format(root.split()[-1])
        if 'README.md' in files: readme += '## Topic\n\n' + readReadme(root)
        for d in dirs:
            if os.path.isfile(d+'/README.md'):
                readme += '* **{0}**: {1}\n'.format(d, readReadme(root + d))
            else: readme += '* **{}**\n'.format(d)    
        for f in files:
            readme += '* **{}**' + checkFile(root + f)
        if ':' in readme:
            with open(root + '/README.md') as f:
                f.write(readme)
