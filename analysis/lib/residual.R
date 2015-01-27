source("def_data.r")

library(car)
library(MASS)

data=def_data()
lm=lm(log(gross)~log(weight_budget)+weight_cast1+weight_cast2+weight_cast3+weight_director+weight_genres+weight_month+weight_superstar,data=data)

str(lm$residuals)
par(mfrow = c(2,2))
cr.plot(lm1,"weight_budget")
cr.plot(lm1,"weight_cast1")
cr.plot(lm1,"weight_cast2")
cr.plot(lm1,"weight_cast3")
cr.plot(lm1,"weight_director")
cr.plot(lm1,"weight_genres")
cr.plot(lm1,"weight_month")
cr.plot(lm1,"weight_superstar")

qplot(log2(weight_budget),log(gross),data=data)
qplot(weight_cast1,log(gross),data=data)
qplot(weight_cast2,log(gross),data=data)
qplot(weight_cast3,log(gross),data=data)
qplot(weight_director,log(gross),data=data)
qplot(weight_genres,log(gross),data=data)
qplot(weight_month,log(gross),data=data)
qplot(weight_superstar,log(gross),data=data)

summary(lm1)

