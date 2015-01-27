#從sql取得資料的function
test_data=function(){
  
  library(rJava)
  library(DBI)
  library(RJDBC)
  library(RSQLServer)
  
  drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
  conn = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDBComplete","sa","passw0rd")
  
  sqlText = paste('SELECT ca.pkno, ROUND(Log(li.budget),4) budget,ca.weight_cast1, ca.weight_cast2, ca.weight_cast3,di.weight_director,ge.weight_genres,mo.weight_month,su.weight_superstar
                    FROM weight_cast ca, weight_director di, weight_genres ge, weight_month mo, weight_superstar su,movie_list li
                    WHERE ca.pkno=di.pkno
                    AND ca.pkno=ge.pkno
                    AND ca.pkno=mo.pkno
                    AND ca.pkno=su.pkno
                    AND ca.pkno=li.pkno')
  
  queryResults = dbGetQuery(conn,sqlText)
  dbDisconnect(conn)
  
  
  pkno=queryResults$pkno
  weight_budget=as.numeric(queryResults$budget)
  weight_cast1=as.numeric(queryResults$weight_cast1)
  weight_cast2=as.numeric(queryResults$weight_cast2)
  weight_cast3=as.numeric(queryResults$weight_cast3)
  weight_director=as.numeric(queryResults$weight_director)
  weight_genres=as.numeric(queryResults$weight_genre)
  weight_month=round(as.numeric(queryResults$weight_month),4)
  weight_superstar=as.numeric(queryResults$weight_superstar)
  
  weight_budget=round((weight_budget-min(weight_budget))/(max(weight_budget)-min(weight_budget)),5)
  screens=0.5
  

  

  data=data.frame(pkno,screens,weight_budget,weight_cast1,weight_cast2,weight_cast3,weight_director,weight_genres,weight_month,weight_superstar)
  
  return(data)
}