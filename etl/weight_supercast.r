library(rJava)
library(DBI)
library(RJDBC)
library(RSQLServer)

drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
conn = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDB","sa","passw0rd")

sqlText = paste('SELECT DISTINCT cc.cast
                FROM convHistRateByYear b, (SELECT pkno,title, weekendgross    		                                       FROM boxoffice 
                WHERE weekend=1
                AND CONVERT(char(4),date)>=2004) w
                ,(SELECT pkno
                FROM boxoffice 
                GROUP BY pkno
                HAVING sum(weekendgross) >= 300000) s
                ,cast15 cc
                WHERE b.pkno = s.pkno  
                AND s.pkno = w.pkno
                AND b.pkno=cc.pkno')

queryResults = dbGetQuery(conn,sqlText)


sqlText2 = paste('SELECT  name, gitems
                 FROM actor2')
queryResults2 = dbGetQuery(conn,sqlText2)
dbDisconnect(conn)

ta=matrix(0,nrow=length(queryResults$cast),ncol=2)
ta[,1]=queryResults$cast
da=matrix(0,nrow=length(queryResults2$name),ncol=2)
da[,1]=queryResults2$name
da[,2]=queryResults2$gitems

for(i in 1:dim(ta)[1]){
  if(length(which(da[,1]==ta[i,1]))!=0){
    ta[i,2]=as.numeric(da[which(da[,1]==ta[i,1]),2])
  }
}
nu_item=as.numeric(ta[,2])
super_star=ta[which(nu_item>131500.0),1]


#-----------------------
conn2 = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDBComplete","sa","passw0rd")

sqlText5= paste('SELECT li.pkno
                FROM movie_list li
                WHERE CONVERT(char(4),releasedate)=2014
                AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
                AND budget>300000')
queryResults5 = dbGetQuery(conn2,sqlText5)


sqlText6= paste('SELECT ca.pkno,ca.cast
                FROM movie_list li,(SELECT pkno,cast FROM cast) ca
                WHERE CONVERT(char(4),releasedate)=2014
                AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
                AND budget>300000
                AND li.pkno=ca.pkno')
queryResults6 = dbGetQuery(conn2,sqlText6)
pkno=queryResults5$pkno

#-------------------------------------
count=matrix(0,ncol=2,nrow=length(pkno))
count[,1]=pkno
for(i in 1:dim(queryResults5)[1]){
  n=queryResults6$cast[which(queryResults6$pkno==queryResults5$pkno[i])]
  for(j in 1:length(n)){
  le=length(which(super_star==n[j]))
  if(le!=0){count[i,2]=as.numeric(count[i,2])+1}
  }
}
cc=as.numeric(count[,2])
cc=(cc-min(cc))/(max(cc)-min(cc))
count[,2]=round(cc,4)
dbWriteTable(conn2, "weight_superstar", count)
