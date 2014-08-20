#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

# Generate how many random values
Generate = 100
xrandom = []
yrandom = []
speedrandom = []

random.seed()

for idx in range(Generate):
    x = random.randint(1,255)
    while(x in xrandom):
        x = random.randint(1,255)
    xrandom.append(x)
    
    y = random.randint(1,191)
    while(y in yrandom):
        y = random.randint(1,191)
    yrandom.append(y)
    
    speed = random.randint(1,3)
    speedrandom.append(speed)

f = open('randomvalues.asm', 'w')
f.write("xrandpos\t\tdw xranddata\n")
f.write("yrandpos\t\tdw yranddata\n")
f.write("speedrandpos\tdw speedranddata\n\n")

for idx in range(len(xrandom)):
    if idx == 0:
        f.write("xranddata\n")
    f.write("\t\tdb $%x\n" % (xrandom[idx]))

f.write("\t\tdb $0\n\n")

for idx in range(len(yrandom)):
    if idx == 0:
        f.write("yranddata\n")
    f.write("\t\tdb $%x\n" % (yrandom[idx]))

f.write("\t\tdb $0\n\n")
    
for idx in range(len(speedrandom)):
    if idx == 0:
        f.write("speedranddata\n")
    f.write("\t\tdb $%x\n" % (speedrandom[idx]))

f.write("\t\tdb $0\n")

f.close()
