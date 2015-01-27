#!/usr/bin/python 
import sys 


for line in sys.stdin:
	if "," not in line: continue
	(star,year_gross) = (None, 0)
	(pkno, gross, sort, cast, year) = line.strip().split(",")
	star=cast
	year_gross=year+"##"+gross
	print star + "\t" +year_gross
