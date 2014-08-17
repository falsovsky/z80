#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import random

random.seed()

NumStars = 10

f = open('starrnd.asm', 'w')

f.write("StarRnd\n")

for x in range(NumStars):
    x = random.randint(0,256 - 1)
    y = random.randint(0,192 - 1)
    #z = random.randint(0,10)
    #f.write("\t\tdb %i, %i, %i\n" % (y ,x ,z))
    f.write("\t\tdb %i, %i\n" % (y ,x))

f.close()
