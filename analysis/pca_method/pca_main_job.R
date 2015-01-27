source("def_data.r")
source("randomforest_pca.r")
source("regression_model_pca.r")
source("pca_data_func.r")

raw_data=def_data()
pca_data=pca_data()
data=cbind(raw_data[,1:3],pca_data)
#取得data
index=sample(c(1,2),dim(data)[1],c(0.7,0.3),replace=T)
train_data=data[which(index==1),]
test_data=data[which(index==2),]
#隨機選取 train_data 和 test_data
classifier=def_randomForest(20141229,train_data,test_data)
#建立分類模型
class=classifier[[1]]
#看test_data 被分到哪一類
lm1=regression_model(0,1,2)
lm2=regression_model(1,2,3)
lm3=regression_model(2,3,4)
lm4=regression_model(3,4,5)
lm5=regression_model(4,5,6)
lm6=regression_model(5,6,0)
model=list(lm1,lm2,lm3,lm4,lm5,lm6)
#每個區間分別建立預測模型
fit = vector(length=dim(test_data)[1])
lwr = vector(length=dim(test_data)[1])
upr = vector(length=dim(test_data)[1])
conclusion=data.frame(test_data[,c(1,2)],class,log(test_data[,3]),fit,lwr,upr)
#建立個放結果的地方
for(i in 1:dim(test_data)[1]){
  pred=predict(model[[class[i]]],newdata=test_data[i,4:10],interval="prediction", level = 0.9)
  conclusion[i,5]=pred[1]
  conclusion[i,6]=pred[2]
  conclusion[i,7]=pred[3]
}
#依照分類結果丟進那個區間的預測模型 將預測結果 和預測區間的上下界

lm=lm(log(gross)~Comp.1+Comp.2+Comp.3+Comp.4+Comp.5+Comp.6+Comp.7,data=train_data)
#lm=lm(log(gross)~log_budget+weight_cast1+weight_cast2+weight_cast3+weight_director+weight_genres+weight_month+weight_superstar,data=train_data)

pred=predict(lm,newdata=test_data[,4:10],interval="prediction", level = 0.9)#原本4:11
conclusion2=data.frame(test_data[,c(1,2)],class,log(test_data[,3]),pred)
#不分類直接做迴歸模型預測結果

co=0
for(i in 1:dim(test_data)[1]){
  if( conclusion[i,4]<= conclusion[i,7] & conclusion[i,4]>=conclusion[i,6]) co=co+1  
}
co/dim(test_data)[1]
#分類預測的準確率
co2=0
for(i in 1:dim(test_data)[1]){
  if( conclusion2[i,4]<= conclusion2[i,7] & conclusion2[i,4]>=conclusion2[i,6]) co2=co2+1  
}
co2/dim(test_data)[1]
#不分類預測的準確率

cor(exp(conclusion[,4]),exp(conclusion[,5]))
cor(exp(conclusion2[,4]),exp(conclusion2[,5]))
summary(lm)
