source("def_data.r")
source("pca_data_func.r")

raw_data=def_data()
pca_data=pca_data()
queryResults=cbind(raw_data[,1:3],pca_data)
head(queryResults)

gross=queryResults$gross
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
Comp.1=as.numeric(queryResults$Comp.1)
Comp.2=as.numeric(queryResults$Comp.2)
Comp.3=as.numeric(queryResults$Comp.3)
Comp.4=as.numeric(queryResults$Comp.4)
Comp.5=as.numeric(queryResults$Comp.5)
Comp.6=as.numeric(queryResults$Comp.6)
Comp.7=as.numeric(queryResults$Comp.7)


index=sample(c(1,2),length(pkno),c(0.8,0.2),replace=T)
data=cbind(group2,Comp.1,Comp.2,Comp.3,Comp.4,Comp.5,Comp.6,Comp.7)
colnames(data)=c("group_1","group_2","group_3","group_4","group_5","group_6","Comp.1","Comp.2","Comp.3","Comp.4","Comp.5","Comp.6","Comp.7")

#train_data=data[which(index==1),]
#以上為決定train data
#-----------------------------------------------------------------------------
test_data=data[which(index==2),]
train_data=data[which(index==1),]
#以上為決定test_data

library(neuralnet)
library(psych)

concrete_model=neuralnet(group_1+group_2+group_3+group_4+group_5+group_6~Comp.1+Comp.2+Comp.3+Comp.4+Comp.5+Comp.6+Comp.7, hidden=c(15,10),data=train_data, algorithm='sag' ,threshold = 0.2, stepmax = 1e+06 ,  err.fct="ce", linear.output=FALSE)

model_result=compute(concrete_model, test_data[,7:13])
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
correct=compare[1,1]+compare[2,2]+compare[3,3]+compare[4,4]+compare[5,5]+compare[6,6]
correct_rate=correct/dim(test_data)[1]
one_factor_correct_rate=(correct+compare[1,2]+compare[2,1]+compare[2,3]+compare[3,2]+compare[4,3]+compare[3,4]+compare[4,5]+compare[5,4]+compare[5,6]+compare[6,5])/dim(test_data)[1]



#看結果