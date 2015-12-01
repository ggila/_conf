#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import re
import sys

includePattern = re.compile('#include ([<"])([^">]+)[">]')

pName = os.getcwd()
print (
"project name: {0}\n"
"user : {1}"
.format(pName[pName.rfind('/') + 1:], os.environ['USER']))

exit(0)
