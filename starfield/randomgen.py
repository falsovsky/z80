#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

# Generate how many random values
MAX_STARS = 10
Generate = 100
xrandom = []
yrandom = []
speedrandom = []

random.seed()

for idx in range(MAX_STARS):
    x = random.randint(1,250)
    while(x in xrandom):
        x = random.randint(1,250)
    xrandom.append(x)

    speed = random.randint(1,3)
    speedrandom.append(speed)

for idx in range(Generate):
    y = random.randint(1,191)
    while(y in yrandom):
        y = random.randint(1,191)
    yrandom.append(y)

f = open('randomvalues.asm', 'w')
f.write("xrandpos dw xranddata\n")
f.write("yrandpos dw yranddata\n")
f.write("speedrandpos dw speedranddata\n\n")

for idx in range(len(xrandom)):
    if idx == 0:
        f.write("xranddata\n")
    f.write("\t\tdb %i\n" % (xrandom[idx]))

f.write("\t\tdb 0\n\n")

for idx in range(len(yrandom)):
    if idx == 0:
        f.write("yranddata\n")
    f.write("\t\tdb %i\n" % (yrandom[idx]))

f.write("\t\tdb 0\n\n")
    
for idx in range(len(speedrandom)):
    if idx == 0:
        f.write("speedranddata\n")
    f.write("\t\tdb %i\n" % (speedrandom[idx]))

f.write("\t\tdb 0\n")

f.close()
