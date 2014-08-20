#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import random

NumStars = 10
xlist = []
ylist = []

f = open('starrnd.asm', 'w')

for x in range(NumStars):
    random.seed()
    x = random.randint(0,256 - 1)
    while(x in xlist):
        x = random.randint(0,256 - 1)
    xlist.append(x)
    
    y = random.randint(0,192 - 1)
    while(y in ylist):
        y = random.randint(0,192 - 1)
    ylist.append(y)

xlist.sort()
ylist.sort()
    
f.write("StarRnd\n")

for idx in range(NumStars):
    f.write("\t\tdb %i, %i\n" % (xlist[idx], ylist[idx]))

f.close()
