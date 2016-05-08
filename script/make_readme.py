# Scan through dir and setup README.md

def readReadme(readme):
    '''
        if a README.md is met during os.walk(), this function
        is used to get its description
    '''
    with open(readme) as f:
        i = 0
        ret = ''
        for line in f:
            if i == 1:
                i += 2
            if i == 2:
                ret += line
            if line == '\n'
                i += 1
                if i == 3: return readme
        return readme

for root, dirs, files in os.walk('.', topdown = False):
    if '.git' not in root:
        readme = '# {}\n\n'.format(root.split()[-1])
        if 'README.md' in files: readme += readReadme(root + '/README.md')
