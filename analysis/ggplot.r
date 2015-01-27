library(ggplot2)


con=data.frame(c(1:dim(test_data)[1]),conclusion,conclusion2[,6:7])
names(con)[1]="no"
names(con)[5]="log"

nu=dim(test_data)[1]%/%50+1

for(i in 1:nu){
  if(i == nu){
    con2=con[((i-1)*50+1):dim(test_data)[1],]
    se=ggplot(con2, aes(x=no, y=log)) + geom_line(size=.8)
    se2=se+geom_line(aes(y=lwr), colour="red")+geom_line(aes(y=upr), colour="red")
    se2+geom_line(aes(y=lwr.1), colour="blue", linetype="dotted")+geom_line(aes(y=upr.1), colour="blue", linetype="dotted")
    
   }else{ 
    con2=con[((i-1)*50+1):(i*50),]
    se=ggplot(con2, aes(x=no, y=log)) + geom_line(size=.8)
    se2=se+geom_line(aes(y=lwr), colour="red")+geom_line(aes(y=upr), colour="red")
    se2+geom_line(aes(y=lwr.1), colour="blue", linetype="dotted")+geom_line(aes(y=upr.1), colour="blue", linetype="dotted")
    }
}
#黑色的實際值 紅色的線是分類預測的預測區間 藍色的是未分類的預測區間