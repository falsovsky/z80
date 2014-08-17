#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import random

random.seed()

NumStars = 10

f = open('starrnd.asm', 'w')

f.write("StarRnd db %i\n" % (3 * NumStars))

for x in range(NumStars):
    x = random.randint(0,256)
    y = random.randint(0,192)
    z = random.randint(0,10)
    f.write("db %i, %i, %i\n" % (x ,y ,z))

f.close()
