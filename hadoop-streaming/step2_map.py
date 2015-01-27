#!/usr/bin/python
import sys

for line in sys.stdin:
    if "\t" not in line: continue
    (star, year_gross) = line.strip().split("\t")
    dic = {'2004': 0, '2005': 0, '2006': 0, '2007': 0, '2008': 0, '2009': 0, '2010': 0, '2011': 0, '2012': 0, '2013': 0,'2014': 0}
    gross = year_gross.split("-")

    for i in range(0, len(dic)):
        dic[str(int(i) + 2004)] = float(gross[int(i) + 1])
    for i in range(0, len(dic)):
        if dic[str(2014 - int(i))] == 0:
            for j in range(i + 1, len(dic)):
                if dic[str(2014 - int(j))] != 0:
                    dic[str(2014 - int(i))] = dic[str(2014 - int(j))]
                    break
    k = -1
    for i in range(0, len(dic)):
        if dic[str(2014 - int(i))] == 0:
            k = i
            break

    if k != -1:
        for i in range(k, len(dic)):
            dic[str(2014 - int(i))] = dic[str(2014 - int(k - 1))]
    yg = ""
    for i in range(0, len(dic)):
        yg = yg + "-" + str(dic[str(int(i) + 2004)])
    print star + "\t" + yg

