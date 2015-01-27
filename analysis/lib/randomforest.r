#產生分類模型 會回傳test_data分類結果 和分類準確率 和差一類的準確率
def_randomForest=function(seed,train_data,test_data){

require('randomForest')
set.seed(seed)

ba.tree=randomForest(group~screens+weight_budget+weight_cast1+weight_cast2+weight_cast3+weight_director+weight_genres+weight_month+weight_superstar, data=train_data, importance=T, proximity=T ,ntree=1000)
#print(ba.tree)
#round(importance(ba.tree),2)

pred=predict(ba.tree, newdata=test_data[,4:12])
pred=round(pred)
compare2=table(real=test_data$group,Predict=pred)
correct2=compare2[1,1]+compare2[2,2]+compare2[3,3]+compare2[4,4]+compare2[5,5]+compare2[6,6]
correct_rate2=correct2/dim(test_data)[1]
one_factor_correct_rate2=(correct2+compare2[1,2]+compare2[2,1]+compare2[2,3]+compare2[3,2]+compare2[4,3]+compare2[3,4]+compare2[4,5]+compare2[5,4]+compare2[5,6]+compare2[6,5])/dim(test_data)[1]

ans=list(pred,correct_rate2,one_factor_correct_rate2)
return(ans)
}