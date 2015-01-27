source("def_data.r")
source("randomforest.r")
source("regression_model.r")
source("get_testdata.r")
data=def_data()
test_data=test_data()
#���odata
train_data=data

class=def_randomForest(20141229,train_data,test_data)
#�إߤ����ҫ�

lm1=regression_model(0,1,2)
lm2=regression_model(1,2,3)
lm3=regression_model(2,3,4)
lm4=regression_model(3,4,5)
lm5=regression_model(4,5,6)
lm6=regression_model(5,6,0)
model=list(lm1,lm2,lm3,lm4,lm5,lm6)
#�C�Ӱ϶����O�إ߹w���ҫ�
fit = vector(length=dim(test_data)[1])
lwr = vector(length=dim(test_data)[1])
upr = vector(length=dim(test_data)[1])
conclusion=data.frame(test_data[,1],class,fit,lwr,upr)
#�إ߭ө񵲪G���a��
for(i in 1:dim(test_data)[1]){
  pred=predict(model[[class[i]]],newdata=test_data[i,2:10],interval="prediction", level = 0.9)
  conclusion[i,3]=pred[1]
  conclusion[i,4]=pred[2]
  conclusion[i,5]=pred[3]
}
#�̷Ӥ������G��i���Ӱ϶����w���ҫ� �N�w�����G �M�w���϶����W�U��

