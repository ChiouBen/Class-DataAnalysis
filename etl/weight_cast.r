database='IMDB'
sqlText='SELECT w.pkno , cc.priority4c, Log(s.totalgross) gross,  CONVERT(char(4),w.date) year,cc.cast
                FROM (SELECT pkno,title, weekendgross, date
                FROM boxoffice 
                WHERE weekend=1) w
                ,(SELECT pkno ,sum(weekendgross) totalgross
                FROM boxoffice 
                GROUP BY pkno
                HAVING sum(weekendgross) >= 300000) s
                ,cast_pri cc
                ,convHistRateByYear b
                WHERE b.pkno=s.pkno 
                AND s.pkno = w.pkno
                AND s.pkno = cc.pkno
                AND cc.priority4c<10
                ORDER BY year DESC'
queryResults2 = query(database,sqlText)

year=as.numeric(queryResults2$year)
gross=as.numeric(queryResults2$gross)
pri=as.numeric(queryResults2$priority4c)
gross=(gross-min(gross))/(max(gross)-min(gross))
#將票房打到0~1區間


sqlText4= paste('SELECT DISTINCT cc.cast
                FROM (SELECT pkno,title, weekendgross, date
                FROM boxoffice 
                WHERE weekend=1
                AND CONVERT(char(4),date)>=2004) w
                ,(SELECT pkno
                FROM boxoffice 
                GROUP BY pkno
                HAVING sum(weekendgross) >= 300000) s
                ,cast_pri cc
                ,convHistRateByYear b
                WHERE b.pkno=s.pkno 
                AND s.pkno = w.pkno
                AND s.pkno = cc.pkno
                AND cc.priority4c<6')
queryResults4 = query(database,sqlText4)
cast_f=queryResults4$cast

we=matrix(0,nrow=length(cast_f),ncol=13)
colnames(we)=c('name',2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
we[,1]=cast_f

for(j in 1:12){
  for(i in 1:length(cast_f)){
    if(j==1){vector=gross[which(queryResults2$cast==we[i,1] & year<(2003+j))]}
    else{vector=gross[which(queryResults2$cast==we[i,1] & year==(2002+j))]}
    we[i,(1+j)]=round(mean(vector), 4)
  }
}
#--------------------------------------------------
for(i in 1:dim(we)[1]){
  m=which(we[i,2:13]=='NaN')
  n=which(we[i,2:13]!='NaN')
  if(min(n)!=1){we[i,2:min(n)]=rep(we[i,2:13][min(n)],(min(n)-1))}
  if(length(n)>1){
    for(r in 1:(length(n)-1)){
      if((n[r+1]-n[r])>1){
        we[i,2:13][(n[r]+1):(n[r+1]-1)]=rep(we[i,2:13][n[r]],(n[r+1]-n[r]-1))}
    }
  }
  if(max(n)!=12){
    we[i,2:13][(max(n)+1):12]=rep(we[i,2:13][max(n)],(12-max(n)))
  }
}

#------------------------------------------------
conn2 = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDBComplete","sa","passw0rd")

sqlText3= paste('SELECT li.pkno,topgenres,currency4b,budget,topdirector,topgenres,SUBSTRING(CONVERT(char(10),releasedate) ,6,2) month
FROM movie_list li
WHERE CONVERT(char(4),releasedate)=2014
AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
AND budget>300000')

sqlText4= paste('SELECT ca.pkno,ca.cast
FROM movie_list li,(SELECT pkno,cast FROM cast WHERE priority4c in (1,2,3)) ca
WHERE CONVERT(char(4),releasedate)=2014
AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
AND budget>300000
AND li.pkno=ca.pkno
')

queryResults3 = dbGetQuery(conn2,sqlText3)
weight_cast=matrix(0,ncol=4,nrow=length(queryResults3$pkno))
weight_cast[,1]=queryResults3$pkno
queryResults4 = dbGetQuery(conn2,sqlText4)

#------------------------------------------------
for(i in 1:dim(queryResults3)[1]){
  cast=queryResults4[which(queryResults4$pkno==queryResults3$pkno[i]),2]
  if(length(which(we[,1]==cast[1]))!=0) weight_cast[i,2]=we[which(we[,1]==cast[1]),11] else weight_cast[i,2]=0.16
  if(length(which(we[,1]==cast[2]))!=0) weight_cast[i,3]=we[which(we[,1]==cast[2]),11] else weight_cast[i,3]=0.16
  if(length(which(we[,1]==cast[3]))!=0) weight_cast[i,4]=we[which(we[,1]==cast[3]),11] else weight_cast[i,4]=0.16
}
for(i in 1:dim(queryResults3)[1]){
  weight_cast[i,2:4]=sort(weight_cast[i,2:4],decreasing = T)
}
dbWriteTable(conn2, "weight_cast", weight_cast)
