query=function(database,sqlText){
  library(rJava)
  library(DBI)
  library(RJDBC)
  library(RSQLServer)
  drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
  conn = dbConnect(drv,paste("jdbc:sqlserver://localhost:1433;databaseName=",database),"sa","passw0rd")
  sqlText= paste(sqlText)
  queryResults = dbGetQuery(conn,sqlText)
  dbDisconnect(conn)
  return(queryResults)
}

writetable=function(datablase,basetable,data){
  library(rJava)
  library(DBI)
  library(RJDBC)
  library(RSQLServer)
  drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
  conn = dbConnect(drv,paste("jdbc:sqlserver://localhost:1433;databaseName=",database),"sa","passw0rd")
  print(dbWriteTable(conn, basetable, data)) 
  dbDisconnect(conn)
}