pca_data=function(){
source("def_data.r")
queryResults=def_data()
queryResults.pr <- princomp(~as.numeric(weight_budget)+as.numeric(screens)+as.numeric(weight_cast1)+as.numeric(weight_cast2)+as.numeric(weight_cast3)+as.numeric(weight_director)+as.numeric(weight_genres)+as.numeric(weight_month)+as.numeric(weight_superstar), data=queryResults,cor=F)
colnames(queryResults[,-c(1)])
summary(queryResults.pr, loadings=T)

queryResults.pred <- predict(queryResults.pr)
#dim(queryResults.pred) #1808 7

#screeplot(queryResults.pr)
#head(queryResults.pred)
data=queryResults.pred[,1:7]
return(data)
}