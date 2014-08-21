#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

Generate = 100
speedrandom = []

random.seed()

for idx in range(Generate):
    speed = random.randint(1,4)
    speedrandom.append(speed)

f = open('randomvalues.asm', 'w')
f.write("speedrandpos dw speedranddata\n\n")

for idx in range(len(speedrandom)):
    if idx == 0:
        f.write("speedranddata\n")
    f.write("\t\tdb %i\n" % (speedrandom[idx]))

f.write("\t\tdb 0\n")

f.close()
