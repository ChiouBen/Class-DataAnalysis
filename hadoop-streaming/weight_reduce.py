#!/usr/bin/python
import sys

f = open('./table.txt','r')
dict = {}
for l in f.readlines():
    (star, gross) = l.split('\t')
    dict[star] = gross

lastkey=None
weight=[0,0,0]
no=0
#f2 = open("./pk_star.txt", 'r')
for line in sys.stdin:
#for line in f2.readlines():
    if "\t" not in line: continue
    (year_pkno,cast)=line.strip().split("\t")
    (year,key)=year_pkno.strip().split("-")
    if lastkey and lastkey!=key:
        print lastkey + "\t" + str(weight[0]).strip()+'-'+str(weight[1]).strip()+'-'+str(weight[2]).strip()
        lastkey=key
        weight=[0,0,0]
        weight[0]=dict[cast].strip().split("-")[int(year)-2003]
        no=1
    else:
        lastkey=key
        weight[no]=dict[cast].strip().split("-")[int(year)-2003]
        no=no+1
if lastkey:
	print lastkey + "\t" + str(weight[0]).strip()+'-'+str(weight[1]).strip()+'-'+str(weight[2]).strip()
