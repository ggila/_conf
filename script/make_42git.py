# Setup git repository with my 42 work from file 'project'

import os
import sys

# var

readme_init = '''#42
## school project

> This repository is generated with [make_42git.py](https://github.com/ggila/config/blob/master/script/make_42git.py)

Master git branch contains the most recent project
Each project, except currents one, can be found with a git tag (e.g. >> git checkout pushswap)
Current project (project still in development) are stored as submodule ()
Least significant project are stored in \'old\' git branch

* **Master**:
'''

mygit = 'https://github.com/ggila/'

# func

def checkProj(proj: dict, ls: list, error: dict):
    """ Check for each project (find in file 'project')
        if it is actually present and compile.
    """
    if proj not in ls:
        error['fatal'].append(proj + ' not here')
        return
#    if os.system('make -C ' + proj) != 0:
#        error['warning'].append(proj + ' does not compile')
#    os.system('make fclean -C ' + proj)

def print_error(err: dict):
    """ err (dict) collects errors during runtime
    """
    if err['fatal']:
        print('\nerror:')
        for e in err['fatal']: print(e)
    if err['warning']:
        print('\nwarning:')
        for e in err['warning']: print(e)

def gitLink(proj: dict):
    """ Formate current project string for README.md
    """
    return '[{0}]({1}{0}) IN PROGRESS'.format(proj, mygit)

def tagThose(list_proj: list, branch: str):
    """ Setup tag for each project in 'list_proj'
        in git branch 'branch'
    """
    os.system('git checkout ' + branch)
    string_proj = ' '.join(list_proj)
    for p in list_proj:
        os.system('git checkout -b tmp')
        os.system('rm -rf {}'.format(string_proj))
        os.system('git checkout {}'.format(p))
        p_cont = os.popen('ls ' + p).read().replace('\n',' ')
        os.system('cp -r {}/* .'.format(p))
        os.system('git add {}'.format(p_cont))
        os.system('rm -rf ' + p)
        os.system('git add -u')
        os.system('git commit -m \'add {} tag\''.format(p))
        os.system('git tag ' + p)
        os.system('rm -rf ' + p_cont)
        os.system('git checkout ' + branch)
        os.system('git branch -D tmp')

# scan and check file 'project' and create README.md

ls = [a[:-1] for a in list(os.popen('ls'))]      # list 
error = {'fatal':[], 'warning':[]}               # store error when processing 'project'
proj = {'ok':[], 'current':[], 'old':[], 'piscine':[]}       # store projects
i = 'ok'                                         # tmp var

with open(os.path.expanduser('~/config/script/project')) as f, open('README.md', 'w+') as readme:
    readme.write(readme_init)
    for line in f:
        if line == 'Current:\n':
            i = 'current'
        elif line == 'Piscine:\n':
            readme.write('\n* **Piscine** (2 weeks initiation):\n')
            i = 'piscine'
        elif line == 'Old:\n':
            readme.write('\n* **Old**:\n')
            i = 'old'
        elif line != '\n':
            p, comment = line.split(':')
            if i != 'current':
                checkProj(p, ls, error)
            readme.write(' * {0}: {1}\n'.format(p if i != 'current' else gitLink(p), comment[:-1]).replace('_','\\_'))
            proj[i].append(p)

# stop if fatal error

if error['fatal'] or error['warning']:
    print_error(error)
    sys.exit(0)

# Init git

os.system('git init')
os.system('git add README.md')
os.system('git commit -m \'init, add README.md\'')

# Setup 'old' branch

os.system('git checkout -b old')
for p in proj['old']:
    os.system('git add ' + p)
os.system('git commit -m \'add old projects\'')

tagThose(proj['old'], 'old')                # set a tag for each project

os.system('git checkout master')

os.system('git checkout -b piscine')
for p in proj['piscine']:
    os.system('git add ' + p)
os.system('git commit -m \'add {}\''.format(' '.join(proj['piscine'])))

tagThose(proj['piscine'], 'piscine')        # set a tag for each project

os.system('git checkout master')

# Setup submodules for curent project

for p in proj['current']:
    os.system('git submodule add {}'.format(mygit + p + '.git'))
    os.system('git add' + p)
os.system('git add .gitmodules')
os.system('git commit -m \'add submodules\'')

# Setup master branch

os.system('git checkout -b ok')
for p in proj['ok']:
    os.system('git add ' + p)
os.system('git commit -m \'add projects\'')

tagThose(proj['ok'], 'ok')

os.system('git checkout master')
os.system('git merge ok')
os.system('git branch -d ok')

print_error(error)
