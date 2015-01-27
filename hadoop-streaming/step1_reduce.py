#!/usr/bin/python
import sys

(lastkey,year_gross)=(None,"")
dic={'2004':0,'2005':0,'2006':0,'2007':0,'2008':0,'2009':0,'2010':0,'2011':0,'2012':0,'2013':0,'2014':0}
dic2={'2004':0,'2005':0,'2006':0,'2007':0,'2008':0,'2009':0,'2010':0,'2011':0,'2012':0,'2013':0,'2014':0}
#f=open("map.txt",'r')

for line in sys.stdin:
#for line in f.readlines():

    if "\t" not in line: continue

    (key,ygross) = line.strip().split("\t")
    (year,gross)=ygross.split("##")
    if lastkey and lastkey!=key:
        for i in range(0,len(dic)):
            if dic[str(int(i)+2004)]!=0:
                dic[str(int(i)+2004)]=float(dic[str(int(i)+2004)])/int(dic2[str(int(i)+2004)])
            year_gross=year_gross + "-" + str(dic[str(int(i)+2004)])
        print lastkey + "\t" + year_gross
        dic={'2004':0,'2005':0,'2006':0,'2007':0,'2008':0,'2009':0,'2010':0,'2011':0,'2012':0,'2013':0,'2014':0}
        dic2={'2004':0,'2005':0,'2006':0,'2007':0,'2008':0,'2009':0,'2010':0,'2011':0,'2012':0,'2013':0,'2014':0}
        dic[str(year)]=float(dic[str(year)])+float(gross)
        dic2[str(year)]=int(dic2[str(year)])+1
        (lastkey,year_gross)=(key,"")
    else:
        lastkey=key
        dic[str(year)]=float(dic[str(year)])+float(gross)
        dic2[str(year)]=int(dic2[str(year)])+1
if lastkey:
    for i in range(0,len(dic)):
            if dic[str(int(i)+2004)]!=0:
                dic[str(int(i)+2004)]=float(dic[str(int(i)+2004)])/int(dic2[str(int(i)+2004)])
            year_gross=year_gross + "-" + str(dic[str(int(i)+2004)])
    print lastkey + "\t" + year_gross


