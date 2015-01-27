import shutil
import requests
rs = requests.Session()
response = rs.get('http://lvr.land.moi.gov.tw/N11/ImageNumberN13?', stream=True)

with open('img.png', 'wb') as out_file:
    shutil.copyfileobj(response.raw, out_file)
del response
from IPython.core.display import Image
Image("img.png")
--------------------------
password = '1557'
payload = {"command":"login", "rand_code":password, "in_type":"land", "formaturl":""}

response2 = rs.post('http://lvr.land.moi.gov.tw/N11/login.action', data = payload)
print response2
----------------------------
response3 = rs.post("http://lvr.land.moi.gov.tw/N11/pro/setToken.jsp")
#print response3.text
from BeautifulSoup import BeautifulSoup 
soup = BeautifulSoup(response3.text)
input_ary = soup.findAll('input')
token =  input_ary[1]['value']
token
---------------------------
payload2 = {"type":"UXJ5ZGF0YQ==",
"Qry_city":"QQ==",
"Qry_area_office":"QTAy",   #區域代碼
"Qry_paytype":"MQ==",
"Qry_build":"",
"Qry_price_s":"",
"Qry_price_e":"",
"Qry_unit_price_s":"",
"Qry_unit_price_e":"",
"Qry_p_yyy_s":"MTAy",
"Qry_p_yyy_e":"MTAz",
"Qry_season_s":"MQ==",
"Qry_season_e":"OQ==",
"Qry_doorno":"",
"Qry_area_s":"",
"Qry_area_e":"",
"Qry_order":"UUEwOCZkZXNj",
"Qry_unit":"Mg==",
"Qry_area_srh":"",
"Qry_buildyear_s":"",
"Qry_buildyear_e":"",
"Qry_origin":"P",
"Qry_avg":"off",
"struts.token.name":"token",
"token":token}

payload3={
"order":"QA08",
"sort":"1",
"Qry_city":"A",
"Qry_area_office":"A02",  #區域代碼
"Qry_unit":"2",
"rowno":""
} 
------------------------------------------------------
#破解字典
pay5={
"id":0
}

pay6={
'inType':'bGFuZA==',
'caseNo':"",
'Qry_unit':'Mg==',
'struts.token.name':'token',
'token':0
}

text_all={1:'MA==',
2:'MQ==',
3:'Mg==',
4:'Mw==',
5:'NA==',
6:'NQ==',
7:'Ng==',
8:'Nw==',
9:'OA==',
10:'OQ=='
}
text2=['A','E','I','M','Q','U','Y','c','g','k']
text3=['MT','Mj','Mz','ND','NT','Nj','Nz','OD','OT']
text4=['w','x','y','z','0','1','2','3','4','5']
for i in range(11,101):
    if 11<=i & i<=20:
        text_all[i]=text3[0]+text2[i%10-1]+"="
    if 21<=i & i<=30:
        text_all[i]=text3[1]+text2[i%10-1]+"="
    if 31<=i & i<=40:
        text_all[i]=text3[2]+text2[i%10-1]+"="
    if 41<=i & i<=50:
        text_all[i]=text3[3]+text2[i%10-1]+"="
    if 51<=i & i<=60:
        text_all[i]=text3[4]+text2[i%10-1]+"="       
    if 61<=i & i<=70:
        text_all[i]=text3[5]+text2[i%10-1]+"="
    if 71<=i & i<=80:
        text_all[i]=text3[6]+text2[i%10-1]+"="
    if 81<=i & i<=90:
        text_all[i]=text3[7]+text2[i%10-1]+"="
    if 91<=i & i<=100:
        text_all[i]=text3[8]+text2[i%10-1]+"="
for i in range(101,1001):
    text_all[i]=text_all[((i-1)/10+1)][0:3]+text4[i%10-1] 
for i in range(1001,10001):
    if i%10 !=0:
        text_all[i]=text_all[int(str(i)[0:3])+1]+text_all[i%10]
    else:
            text_all[i]=text_all[int(str(i)[0:3])+1]+text_all[10]  
------------------------------------------------
response4 = rs.post("http://lvr.land.moi.gov.tw/N11/QryClass_land.action",data = payload2)
------------------------------------------------
#taipei_daton=open("taipei_dean.txt",'w')
#taipei_daton.write("交易標的:交易年月:交易總價:交易單價:建物移轉總面積:交易筆棟數:建物區段門牌:建物型態:建物現況格局:車位總價:有無管理組織:經緯度:土地區段位置:土地移轉面積:使用分區或編定:屋齡:建物移轉面積:主要用途:主要建材:建築完成年月:總樓層數:建物分層"+"\n")
from math import ceil
import time
from datetime import date,datetime

soup2 = BeautifulSoup(response4.text)
li = soup2.findAll('select',{"id":"page_tol"})
s=li[0].text.split('~')[-1]
print s
a=int(s)
kk=0

b=int(ceil(a/200.0))
pa=[]
for i in range(0,b+1):
    pa.append(i*200)
#print pa
taipei_daton=open("taipei_chusien_0.txt",'w')
start=datetime.now()
for k in range(1,5):
    #taipei_daton=open("taipei_dean_"+k+".txt",'w')  手設定k 並且新開一個檔存下兩百筆
    payload3["rowno"]=pa[k]
    re3 = rs.post('http://lvr.land.moi.gov.tw/N11/LandBuildSort', data = payload3)
    soup3 = BeautifulSoup(re3.text)
    if k==len(pa)-1:#判斷是不是最後一頁 如果是最後一頁 則只要跑到最後一筆
        for i in range((pa[k-1]+1),a+1):#a為總筆數
            kk=kk+1
            tr2 = soup3.find('div',{"id":("full_view"+str(i))})
            tr3=tr2.findAll('tr')
            for ii in range(2,len(tr3)):
                if ii !=7:
                    tr4=tr3[ii].findAll('td')
                    taipei_daton.write(tr4[1].text.encode('utf-8')+":")
            pay5["id"]=i-1
            response5 = rs.post("http://lvr.land.moi.gov.tw/N11/pro/getPointXY.jsp",data=pay5)
            soup5 = BeautifulSoup(response5.text)
            re5_text=soup5.text
            taipei_daton.write(re5_text.encode('utf-8')+":")
            
            pay6['token']=BeautifulSoup(rs.post("http://lvr.land.moi.gov.tw/N11/pro/setToken.jsp").text).findAll('input')[1]['value']
            pay6['caseNo']=text_all[i]
            response6 = rs.post("http://lvr.land.moi.gov.tw/N11/QryClass_getDetailData.action",data=pay6)
            soup6 = BeautifulSoup(response6.text)
            tr10 = soup6.findAll('td',{"class":"popup_box"})
            for qq in tr10:
                tr11=qq.findAll('tr')  
                tr13=tr11[1].findAll('td')  
                for rr in range(0,len(tr13)):
                    if rr==6:
                        taipei_daton.write(tr13[rr].text.encode('utf-8'))
                    else:
                        taipei_daton.write(tr13[rr].text.encode('utf-8')+":")                
            taipei_daton.write("\n")
            time.sleep(2)
    else:#不是最後一頁的情況 一次跑兩百筆
        for i in range((pa[k-1]+1),(pa[k]+1)):
            kk=kk+1
            tr2 = soup3.find('div',{"id":("full_view"+str(i))})
            tr3=tr2.findAll('tr')
            for ii in range(2,len(tr3)):
                if ii !=7:
                    tr4=tr3[ii].findAll('td')
                    taipei_daton.write(tr4[1].text.encode('utf-8')+":")
            pay5["id"]=i-1
            response5 = rs.post("http://lvr.land.moi.gov.tw/N11/pro/getPointXY.jsp",data=pay5)
            soup5 = BeautifulSoup(response5.text)
            re5_text=soup5.text
            taipei_daton.write(re5_text.encode('utf-8')+":")
                       
            pay6['token']=BeautifulSoup(rs.post("http://lvr.land.moi.gov.tw/N11/pro/setToken.jsp").text).findAll('input')[1]['value']
            pay6['caseNo']=text_all[i]
            response6 = rs.post("http://lvr.land.moi.gov.tw/N11/QryClass_getDetailData.action",data=pay6)
            soup6 = BeautifulSoup(response6.text)
            tr10 = soup6.findAll('td',{"class":"popup_box"})
            for qq in tr10:
                tr11=qq.findAll('tr')  
                tr13=tr11[1].findAll('td')  
                for rr in range(0,len(tr13)):
                    if rr==6:
                        taipei_daton.write(tr13[rr].text.encode('utf-8'))
                    else:
                        taipei_daton.write(tr13[rr].text.encode('utf-8')+":")                
            taipei_daton.write("\n")
            time.sleep(2)
taipei_daton.close()#關檔
end=datetime.now()