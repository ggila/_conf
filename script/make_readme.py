# Scan through dir and setup README.md

def readReadme(readme):
    '''
        if a README.md is met during os.walk(), this function is
        used to get its description (4th line and followings ones)
    '''
    with open(readme) as f:
        i = 0
        ret = '## Topic\n\n'
        for line in f:
            if i == 4:
                ret += line
                if line == '\n': return readme
            else: i += 1
        return readme

for root, dirs, files in os.walk('.', topdown = False):
    if '.git' not in root:
        readme = '# {}\n\n'.format(root.split()[-1])
        if 'README.md' in files: readme += readReadme(root + '/README.md')
