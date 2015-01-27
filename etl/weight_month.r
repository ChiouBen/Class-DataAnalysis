library(rJava)
library(DBI)
library(RJDBC)
library(RSQLServer)

drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
conn2 = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDBComplete","sa","passw0rd")

sqlText= paste('SELECT li.pkno,topgenres,currency4b,budget,topdirector,topgenres,SUBSTRING(CONVERT(char(10),releasedate) ,6,2) month
                FROM movie_list li
                WHERE CONVERT(char(4),releasedate)=2014
                AND SUBSTRING(CONVERT(char(10),releasedate) ,6,2) in (11,12)
                AND budget>300000')

queryResults = dbGetQuery(conn2,sqlText)
dbDisconnect(conn2)
month=queryResults$month
monthweigth=c(0.4273859,0.6078838,0.5643154, 0.120332, 0,0.4958506,1,0.68361,0.5788382,0.1587137,0.2748963,0.2126556)
weirthofmonth=matrix(0,ncol=2,nrow=length(month))
weirthofmonth[,1]=queryResults$pkno
for(i in 1:length(month)){
  weirthofmonth[i,2]=monthweigth[as.integer(month[i])]
}
dbWriteTable(conn2, "weight_month", weirthofmonth)
