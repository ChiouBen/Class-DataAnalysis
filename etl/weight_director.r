library(rJava)
library(DBI)
library(RJDBC)
library(RSQLServer)

drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
conn = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDB","sa","passw0rd")

sqlText = paste('SELECT DISTINCT d.director
                FROM (SELECT pkno,title, weekendgross, date
                FROM boxoffice 
                WHERE weekend=1) w
                ,(SELECT pkno
                FROM boxoffice 
                GROUP BY pkno
                HAVING sum(weekendgross) >= 300000) s
                ,directors d
                WHERE  s.pkno = d.pkno
                AND s.pkno = w.pkno')
queryResults = dbGetQuery(conn,sqlText)
director=queryResults$director
#列出各個導演
sqlText2= paste('SELECT w.pkno , Log(s.totalgross) gross, d.director, CONVERT(char(4),w.date) year
                FROM (SELECT pkno,title, weekendgross, date
                FROM boxoffice 
                WHERE weekend=1) w
                ,(SELECT pkno,sum(weekendgross) totalgross
                FROM boxoffice 
                GROUP BY pkno
                HAVING sum(weekendgross) >= 300000) s
                ,directors d
                WHERE  s.pkno = w.pkno
                AND s.pkno = d.pkno
                ORDER BY year DESC;')
queryResults2 = dbGetQuery(conn,sqlText2)
head(queryResults2)
year=as.numeric(queryResults2$year)
gross=queryResults2$gross



gross=(gross-min(gross))/(max(gross)-min(gross))

#將票房打到0~1區間
we=matrix(0,nrow=length(director),ncol=13)
colnames(we)=c('name',2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
we[,1]=director
head(we,6)
for(j in 1:12){
  for(i in 1:length(director)){
    if(j==1){vector=gross[which(queryResults2$director==we[i,1] & year<(2003+j))]}
    else{vector=gross[which(queryResults2$director==we[i,1] & year==(2002+j))]}
    we[i,(1+j)]=round(mean(vector), 4)
  }
}
#產生一個矩陣為每個演員在某年以前的票房平均
#----------------作弊一下...遇到第一次導演的電影
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
#-------------------------------------------------
conn2 = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDBComplete","sa","passw0rd")

sqlText3= paste('SELECT li.pkno,topgenres,currency4b,budget,topdirector,topgenres,SUBSTRING(CONVERT(char(10),releasedate) ,6,2) month
                FROM movie_list li
                WHERE CONVERT(char(4),releasedate)=2014
                AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
                AND budget>300000')

queryResults3 = dbGetQuery(conn2,sqlText3)
weight_director=matrix(0,ncol=2,nrow=length(queryResults3$pkno))
weight_director[,1]=queryResults3$pkno

#------------------------------------------------
for(i in 1:dim(queryResults3)[1]){
  if(length(which(we[,1]==queryResults3$topdirector[i]))!=0) weight_director[i,2]=we[which(we[,1]==queryResults3$topdirector[i]),11] else weight_director[i,2]=0.16
 }
dbWriteTable(conn2, "weight_director", weight_director)
