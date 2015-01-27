#從sql取得資料的function
def_data=function(){

library(rJava)
library(DBI)
library(RJDBC)
library(RSQLServer)

drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
conn = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDB","sa","passw0rd")

sqlText = paste('SELECT b.pkno, bo.weekendgross, sc.screens,b.weight_budget, c.cast1_weight, c.cast2_weight , c.cast3_weight, d.weight_director, g.weight_genres, m.weight_month, su.weight_superstar 
                FROM weight_budget b , weight_cast_final c, 
      		  weight_director_final d, weight_genres g,
                weight_month m, boxoffice bo,
                weight_superstar su, log_budget lo,
                (SELECT pkno,screens
                FROM boxoffice
                WHERE weekend=1) sc
                WHERE b.pkno=c.pkno
                AND b.pkno=d.pkno
                AND b.pkno=g.pkno
                AND b.pkno=m.pkno
                AND b.pkno=bo.pkno
                AND b.pkno=su.pkno
                AND b.pkno=lo.pkno
                AND sc.pkno=b.pkno
                AND weekend=1
                ORDER BY weekendgross DESC')

queryResults = dbGetQuery(conn,sqlText)
dbDisconnect(conn)


pkno=queryResults$pkno
gross=as.numeric(queryResults$weekendgross)
weight_budget=as.numeric(queryResults$weight_budget)
weight_cast1=as.numeric(queryResults$cast1_weight)
weight_cast2=as.numeric(queryResults$cast2_weight)
weight_cast3=as.numeric(queryResults$cast3_weight)
weight_director=as.numeric(queryResults$weight_director)
weight_genres=as.numeric(queryResults$weight_genres)
weight_month=as.numeric(queryResults$weight_month)
weight_superstar=as.numeric(queryResults$weight_superstar)
#log_budget=as.numeric(queryResults$log_budget)
screens=as.numeric(queryResults$screens)

screens[which(screens==99999)]=mean(screens[which(screens!=99999)])
screens=(screens-min(screens))/(max(screens)-min(screens))

br1 = c(3746, 98899, 397473,  6463279, 11947745, 24968602, 207438709)
group=c()
for(j in 1:length(gross)){
  for(i in 1:6){
    if(gross[j]<=br1[i+1] & br1[i]<=gross[j]){
      group[j]=i
    }
  }  
}
#data=data.frame(pkno,group,gross,screens,weight_budget,weight_cast1,weight_cast2,weight_cast3,weight_director,weight_genres,weight_month,weight_superstar,log_budget)
data=data.frame(pkno,group,gross,screens,weight_budget,weight_cast1,weight_cast2,weight_cast3,weight_director,weight_genres,weight_month,weight_superstar)

return(data)
}