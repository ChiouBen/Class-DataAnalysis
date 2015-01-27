library(rJava)
library(DBI)
library(RJDBC)
library(RSQLServer)

drv = JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver","C:/data/sqljdbc4-3.0.jar/sqljdbc4-3.0.jar")
conn = dbConnect(drv,"jdbc:sqlserver://localhost:1433;databaseName=IMDB","sa","passw0rd")

sqlText = paste('SELECT b.pkno, s.weekendgross, b.weight_budget, d.weight_director, g.weight_genres, ROUND(m.weight_month,4) weight_month ,ca.weight_cast1, ca.weight_cast2 ,ca.weight_cast3, st.weight_superstar
                  FROM weight_budget b, weight_director d, weight_genres g, weight_month m
                        , (SELECT pkno, weekendgross
                            FROM boxoffice 
                            WHERE weekend=1) s, weight_cast ca, weight_superstar st
                  WHERE b.pkno=d.pkno
                  AND b.pkno=g.pkno
                  AND b.pkno=m.pkno
                  AND b.pkno=s.pkno
    		          AND b.pkno=ca.pkno
				          AND b.pkno=st.pkno
                  ORDER BY s.weekendgross DESC')

queryResults = dbGetQuery(conn,sqlText)

gross=queryResults$weekendgross
br1 = c(3746, 98899, 397473,  6463279, 11947745, 24968602, 207438709)

group=c()
for(j in 1:length(gross)){
    for(i in 1:6){
    if(gross[j]<=br1[i+1] & br1[i]<=gross[j]){
      group[j]=i
    }
  }  
}
#以上為計算那部電影在哪個區間(1~6)
group2=matrix(0,ncol=6,nrow=length(group))
for(i in 1:length(group)){
  group2[i,group[i]]=1
}
names(group2)=c("group_1","group_2","group_3","group_4","group_5","group_6")

pkno=queryResults$pkno
budget=as.numeric(queryResults$weight_budget)
director=as.numeric(queryResults$weight_director)
genres=as.numeric(queryResults$weight_genres)
month=as.numeric(queryResults$weight_month)
star1=as.numeric(queryResults$weight_cast1)
star2=as.numeric(queryResults$weight_cast2)
star3=as.numeric(queryResults$weight_cast3)
superstar=as.numeric(queryResults$weight_superstar)
index=sample(c(1,2),length(pkno),c(0.8,0.2),replace=T)
data=cbind(group2,budget,director,genres,month,star1,star2,star3,superstar)
colnames(data)=c("group_1","group_2","group_3","group_4","group_5","group_6","budget","director_test","genres","month","star1_test","star2_test","star3_test","superstar")

#train_data=data[which(index==1),]
#以上為決定train data
#-----------------------------------------------------------------------------
sqlText2 = paste('SELECT b.pkno, s.weekendgross, b.weight_budget, d.weight_director_test, g.weight_genres, ROUND(m.weight_month,4) weight_month ,ca.weight_cast1_test, ca.weight_cast2_test ,ca.weight_cast3_test,  st.weight_superstar
                FROM weight_budget b, weight_director_test d, weight_genres g, weight_month m
                , (SELECT pkno, weekendgross
                 FROM boxoffice 
                 WHERE weekend=1) s, weight_cast_test ca,  weight_superstar st
                 WHERE b.pkno=d.pkno
                 AND b.pkno=g.pkno
                 AND b.pkno=m.pkno
                 AND b.pkno=s.pkno
                 AND b.pkno=ca.pkno
  			         AND b.pkno=st.pkno
                 ORDER BY s.weekendgross DESC')

queryResults2 = dbGetQuery(conn,sqlText2)
dbDisconnect(conn)

star1_test=as.numeric(queryResults2$weight_cast1_test)
star2_test=as.numeric(queryResults2$weight_cast2_test)
star3_test=as.numeric(queryResults2$weight_cast3_test)
director_test=as.numeric(queryResults2$weight_director_test)
data_test=cbind(group2,budget,director_test,genres,month,star1_test,star2_test,star3_test,superstar)
colnames(data_test)=c("group_1","group_2","group_3","group_4","group_5","group_6","budget","director_test","genres","month","star1_test","star2_test","star3_test","superstar")
test_data=data_test[which(index==2),]
train_data=data_test[which(index==1),]
#以上為決定test_data

library(neuralnet)
library(psych)

concrete_model=neuralnet(group_1+group_2+group_3+group_4+group_5+group_6~budget+director_test+genres+month+star1_test+star2_test+star3_test+superstar, hidden=c(30,10),data=train_data, algorithm='sag' ,threshold = 0.2, stepmax = 1e+06 ,  err.fct="ce", linear.output=FALSE)

model_result=compute(concrete_model, test_data[,7:14])
plot(concrete_model)
resault=model_result$net.result
#以上為訓練模型

re=c()
for(i in 1:dim(test_data)[1]){
  re[i]=which(resault[i,]==max(resault[i,]))
}

library(RSNNS)
compare=confusionMatrix(group[which(index==2)],re)
correct=compare[1,1]+compare[2,2]+compare[3,3]+compare[4,4]+compare[5,5]+compare[6,6]
correct_rate=correct/dim(test_data)[1]
one_factor_correct_rate=(correct+compare[1,2]+compare[2,1]+compare[2,3]+compare[3,2]+compare[4,3]+compare[3,4]+compare[4,5]+compare[5,4]+compare[5,6]+compare[6,5])/dim(test_data)[1]
compare
#看結果