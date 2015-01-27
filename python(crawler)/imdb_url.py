import requests 
from bs4 import BeautifulSoup
for y in range(2003,2014):
    year=y
    page_format='http://www.imdb.com/search/title?sort=moviemeter,asc&start=%d&title_type=feature&year=%d,%d'
    res = requests.get(page_format%(1,year,year))
    res_text=res.text.encode('utf-8')
    soup=BeautifulSoup(res_text)
    rec=soup.findAll('td',{"class":"title"})
    n1=soup.findAll('div',{"id":"left"})[0].text.split(' ')[2].split('titles.')[0].split(',')
    number=int(n1[0]+n1[1])

    run=number/50+1
    j=0

    url=open(str(year)+".txt",'w')


    for i in range(0,run):
        res = requests.get(page_format%(50*i+1,year,year))
        res_text=res.text.encode('utf-8')
        soup=BeautifulSoup(res_text)
    
        rec=soup.findAll('td',{'class':'title'})
        for k in range(0,len(rec)):
            ti=rec[k].find('a',{'href':True})
            link=[ti['href']]
            j=j+1
            url.write(link[0]+"\n")
    url.close()        