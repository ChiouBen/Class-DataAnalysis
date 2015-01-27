#!/usr/bin/python
import sys

#f = open("tt.txt", 'r')
for line in sys.stdin:
#for line in f.readlines():
	if "," not in line: continue
	(pkno, gross, sort, cast, year) = line.strip().split(",")
	print year+'-'+pkno + '\t' +cast
