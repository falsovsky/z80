#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

if len(sys.argv) < 2:
    sys.stderr.write("Usage: %s source.bf" % sys.argv[0])
    sys.exit(1)

allowed_chars = (">", "<", "+", "-", ".", ",", "[", "]")

file = open(sys.argv[1], 'r')
print "ORG $9400"
sys.stdout.write("src db \"")
for char in file.read():
    if char in allowed_chars:
        sys.stdout.write(char)
    else:
        continue
print "\", 0"

