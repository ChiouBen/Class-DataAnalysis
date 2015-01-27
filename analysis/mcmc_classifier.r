source("def_data.r")
source("randomforest.r")

data=def_data()
correct=c()
corr_one=c()

for(i in 1:1000){
  set.seed(i)
  index=sample(c(1,2),dim(data)[1],c(0.8,0.2),replace=T)
  train_data=data[which(index==1),]
  test_data=data[which(index==2),]
  
  classifier=def_randomForest(i,train_data,test_data)
  
  #confusion=table(real=test_data$group,Predict=classifier[[1]])
  correct[i]=classifier[[2]]
  corr_one[i]=classifier[[3]]
  rm(list=c("index","train_data","test_data","classifier"))
}
