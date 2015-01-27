import requests
from bs4 import BeautifulSoup
import urlparse
import time
from datetime import date,datetime

count=0
f=open("m1.txt",'r')
fe=open("movie_error_1.txt",'w')
fd=open("movie_detail_1.txt",'w')
fs=open("movie_star_1.txt",'w')
fp=open("movie_price_1.txt",'w')
start=datetime.now()
for line in f.readlines():
    try:
        line=line.replace('\n','')
        pk=line.split('/')[-2]

        res = requests.get(line)
        soup = BeautifulSoup(res.text)
        
        #-------title
        title='null'
        ti=soup.find('h1',{"class":"header"})
        title=ti.find('span',{"class":"itemprop"}).text
        title=title.encode('utf-8')
    
        
        #-------------------Genres
        Genres=[]
        li=soup.find('div',{"class":"infobar"})
        li2=li.findAll('a',{"href":True})
        for i in range(0,len(li2)-1):
            Genres.append(li2[i].text.encode('utf-8'))
        
        
        #----------------director
        director=[]
        di=soup.find('div',{"itemprop":"director"})
        di2=di.findAll('a',{"href":True})
        for i in range(0,len(di2)):
            director.append(di2[i].text.encode('utf-8'))

        
        #------------------------star
        si=soup.find('table',{"class":"cast_list"})
        si2=si.findAll('tr')
        star=[]

        for i in range(1,len(si2)):
            if(si2[i].text=='Rest of cast listed alphabetically:'): break
            si3=si2[i].findAll('td')[1].text
            si3=si3.replace('\n','')
            ss=''
            for k in range(1,len(si3)-1):
                ss=ss+si3[k]
            star.append(ss.encode('utf-8'))
                

        #---------------budget 
        budget=''
        unit=''
        b=None
        de=soup.find('div',{"id":"titleDetails"})
        de2=de.findAll('div',{"class":"txt-block"})
        for i in range(0,len(de2)):
            de3=de2[i].text.replace('\n','').split(':')
            if(de3[0]=='Budget'): b=de3[1].replace(' ','').split('(')[0].replace(',','')
        if(b is not None):
            for e in range(0,len(b)):
                if(b[e].isdigit()==False):
                    unit=unit+b[e]
                else:
                    budget=budget+b[e]    
        
        
        #---------------date
        res3 = requests.get(line+'releaseinfo?ref_=tt_dt_dt')
        soup3 = BeautifulSoup(res3.text)
        da=soup3.find('table',{"class":"subpage_data spFirst"})
        da2=da.findAll('tr')
        date='null'
        for i in range(0,len(da2)):
            da3=da2[i].findAll('td')
            if(da3[0].text=='USA' and da3[2].text==''):
                date=da3[1].text
                break
        if(date=='null'):
            for i in range(0,len(da2)):
                da3=da2[i].findAll('td')
                if(da3[0].text=='USA' and da3[2].text==' (limited)'):
                    date=da3[1].text
                    break
        data=date.encode('utf-8')

        #-------------------price
        res2 = requests.get(line+'business?ref_=tt_dt_bus')
        soup2 = BeautifulSoup(res2.text)
        pr=soup2.find('div',{"id":"tn15content"})
        pr2=pr.text.replace('\n',' ').split(' ')
        cr=0
        j=0
        price=[]
        pdate=[]
        punit=[]
        cc=pr.text.split('\n')
        for i in range(0,len(cc)):
            if(cc[i]=='Weekend Gross'):
                cr=1
                j=i
        if(cr==1):
            cc2=cc[j+1].split(' ')
            for i2 in range(0,len(cc2)):
                m=''
                u2=''
                m2=''
                da=''
                if(cc2[i2]=='(USA)'):
                    m=cc2[i2-1].replace(',','').split(')')[-1]
                    da=cc2[i2+1].replace('(','')+"/"+cc2[i2+2]+"/"+cc2[i2+3].split(')')[0]
                    for e in range(0,len(m)):
                        if(m[e].isdigit()==False):
                            u2=u2+m[e]
                        else:
                            m2=m2+m[e]
                    price.append(m2)
                    pdate.append(da)
                    punit.append(u2)
        
        #---------------write file_detail
        if(cr==1 and len(price)!=0):
            fd.write(pk+"##"+title+"##")
            
            for i3 in range(0,len(director)):
                if(i3==len(director)-1):
                    fd.write(director[i3]+"##")
                else:
                    fd.write(director[i3]+"||")

            fd.write(budget+"||") 
            fd.write(unit.encode('utf-8')) 
            fd.write("##"+data+"##")
            
            fd.write(punit[len(punit)-1].encode('utf-8')) 
            fd.write("||"+price[len(price)-1]+"||") 
            fd.write(pdate[len(pdate)-1]+"##") 
            
            if(len(Genres)==0):
                fd.write("||##")
            else:    
                for i3 in range(0,len(Genres)):
                    if(i3==len(Genres)-1):
                        fd.write(Genres[i3]+"##")
                    else:
                        fd.write(Genres[i3]+"||")
                    
            for i3 in range(0,len(star)):
                if(i3==len(star)-1):
                    fd.write(star[i3]+"\n")
                else:
                    fd.write(star[i3]+"||")
        
        #-------------write file_star
            for i in range(0,len(star)):
                fs.write(star[i]+'\n')
        
        #-------------write file_price
            for i in range(0,len(price)):
                fp.write(punit[i].encode('utf-8')) 
                fp.write(":"+price[i]+":") 
                fp.write(pdate[i]+'\n')             
            count=count+1
    except BaseException, e:
        print line ,e
        fe.write(line+'\n')

end=datetime.now()        
f.close()
fd.close()
fp.close()
fs.close()
fe.close()