library(rJava)
library(DBI)
library(RJDBC)
library(RSQLServer)

drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
conn = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDB","sa","passw0rd")

sqlText = paste('SELECT b.pkno, w.title, w.date, b.stand_budget, w.weekendgross, g.genre
                FROM convHistRateByYear b, (SELECT pkno,title, weekendgross, date
                FROM boxoffice 
                WHERE weekend=1
                AND CONVERT(char(4),date)>=2004) w
                ,(SELECT pkno
                FROM boxoffice 
                GROUP BY pkno
                HAVING sum(weekendgross) >= 300000) s
                ,(SELECT g.pkno,  g.genre
                FROM genres g
                WHERE g.priority4g=1) g
                WHERE b.pkno = s.pkno  
                AND s.pkno = w.pkno
                AND g.pkno=b.pkno
                ORDER BY  w.weekendgross DESC,b.stand_budget DESC ')

queryResults = dbGetQuery(conn,sqlText)
dbDisconnect(conn)
head(queryResults,200)
fac_ge=as.factor(queryResults$genre)
table(fac_ge)
qge=queryResults$genre
qgc=queryResults$weekendgross
pkno=queryResults$pkno

br1 = c(3746, 98899, 397473,  6463279, 11947745, 24968602, 207438709)
'''group=c()
for(j in 1:length(qgc)){
for(i in 1:6){
if(qgc[j]<=br1[i+1] & br1[i]<=qgc[j]){
group[j]=i
}
}  
}'''
#¼Ð°O¸s¶°
#max(qgc[which(group==3)])

br2 = c(0, 0.16, 0.32, 0.48, 0.64, 0.82, 1)
for(j in 1:length(qgc)){
  for(i in 1:6){
    if(qgc[j]<=br1[i+1] & br1[i]<=qgc[j]){
      if(i !=6){  
        qgc[j]=((qgc[j]-br1[i])/(br1[i+1]-br1[i]))*0.16+br2[i]}
      else{qgc[j]=((qgc[j]-br1[i])/(br1[i+1]-br1[i]))*0.18+br2[i]}
    }
  }
}


action=qgc[which(qge==" Action")]
adventure=qgc[which(qge==" Adventure")]
animation=qgc[which(qge==" Animation")]
biography=qgc[which(qge==" Biography")]
comedy=qgc[which(qge==" Comedy")]
crime=qgc[which(qge==" Crime")]
drama=qgc[which(qge==" Drama")]
horror=qgc[which(qge==" Horror")]
others=qgc[which(qge!=" Animation" & qge!=" Adventure" & qge!=" Action" & qge!=" Biography" & qge!=" Comedy" & qge!=" Crime" & qge!=" Drama" & qge!=" Horror" )]
weight=c(mean(action),mean(adventure),mean(animation),mean(biography),mean(comedy),mean(crime),mean(drama),mean(horror),mean(others))
weight=(weight-min(weight))/(max(weight)-min(weight))
#-------------------------------------
conn2 = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDBComplete","sa","passw0rd")

sqlText3= paste('SELECT li.pkno,topgenres,currency4b,budget,topdirector,topgenres,SUBSTRING(CONVERT(char(10),releasedate) ,6,2) month
                FROM movie_list li
                WHERE CONVERT(char(4),releasedate)=2014
                AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
                AND budget>300000')

queryResults3 = dbGetQuery(conn2,sqlText3)
qgc=queryResults3$topgenres
weigthOfgenre=c()

for(j in 1:length(qgc)){
  if(qge[j]==" Action"){
    weigthOfgenre[j]=weight[1]
    next
  }
  if(qge[j]==" Animation"){
    weigthOfgenre[j]=weight[3]
    next
  }
  if(qge[j]==" Adventure"){
    weigthOfgenre[j]=weight[2]
    next
  }
  if(qge[j]==" Biography"){
    weigthOfgenre[j]=weight[4]
    next
  }
  if(qge[j]==" Comedy"){
    weigthOfgenre[j]=weight[5]
    next
  }
  if(qge[j]==" Crime"){
    weigthOfgenre[j]=weight[6]
    next
  }
  if(qge[j]==" Drama"){
    weigthOfgenre[j]=weight[7]
    next
  }
  if(qge[j]==" Horror"){
    weigthOfgenre[j]=weight[8]
    next
  }
  weigthOfgenre[j]=weight[9]
}
weigth_genre=matrix(0,ncol=2,nrow=dim(queryResults3)[1])
weigth_genre[,1]=queryResults3$pkno
weigth_genre[,2]=round(weigthOfgenre,4)

dbWriteTable(conn2, "weight_genres", weigth_genre)


