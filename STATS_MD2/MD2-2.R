# MD2
# 1. Import LifeCycleSavings
df <- LifeCycleSavings
attach(df)
# Fields
# - sr : numeric aggregate personal savings
# - pop15 : population % under 15
# - pop74 : population % over  75
# - dpi   : per capita income
# - ddpi  : gdp growth
# generic linear regression function
general_lreg <- function(vec1,vec2,degree=1,plot=F,print=F,names=c("","")) {
  fit<-lm(vec2~poly(vec1,degree,raw=T)) 
  if(plot){
    plot(vec1,vec2,xlab=names[1],ylab=names[2])
    x <- seq(min(vec1),max(vec1),length.out = length(vec1))
    f <- predict(fit, newdata = data.frame(vec1 = x))
    lines(x,f,col="red",lwd=2)
  }
  if(print){
    print(paste("R-squared:",summary(fit)$r.squared))
  }
  fit
}

# 2. Find correlations between sr and other parameters
# draw conclusions
cor(df)
pairs(df)
# Conclusions 
#  pop15 : weak negative pattern
#  pop75 : weak positive pattern
#  dpi   : weak positive pattern
#  ddpi  : weak positive pattern
# overall  - most of the effect concentrated at the low end 
#  for the latter 3
# 3. Use simple linear regressions on each pair with sr
f_pop15<-general_lreg(pop15,sr,plot=T,print=T,names=c("pop15","sr"))
f_pop75<-general_lreg(pop75,sr,plot=T,print=T,names=c("pop75","sr"))
f_dpi<-general_lreg(dpi,sr,plot=T,print=T,names=c("dpi","sr"))
f_ddpi<-general_lreg(ddpi,sr,plot=T,print=T,names=c("ddpi","sr"))
# - try to explain sr
#  1. Strongest predictor - pop15, inverse
#  2. Others - weak, positive
# 4. Check model conditions, do diagnostics, draw conclusions
#  Independence (graphical)
plot(pop15,f_pop15$residuals,xlab="arg",ylab="residuals")
plot(pop75,f_pop75$residuals,xlab="arg",ylab="residuals")
plot(dpi,f_dpi$residuals,xlab="arg",ylab="residuals")
plot(ddpi,f_ddpi$residuals,xlab="arg",ylab="residuals")
# Autocorrelation
library(car)
(durbinWatsonTest(f_pop15)$p < 0.05)
(durbinWatsonTest(f_pop75)$p < 0.05)
(durbinWatsonTest(f_dpi)$p < 0.05)
(durbinWatsonTest(f_ddpi)$p < 0.05)
#  ^ no autocorrelation found
# Normality
library(nortest)
(lillie.test(f_pop15$residuals)$p.value > 0.05)
(lillie.test(f_pop75$residuals)$p.value > 0.05)
(lillie.test(f_dpi$residuals)$p.value > 0.05)
(lillie.test(f_ddpi$residuals)$p.value > 0.05)
# Homoscedasticity (True - homoscedastic sample)
(ncvTest(f_pop15)$p > 0.05)
(ncvTest(f_pop75)$p > 0.05)
(ncvTest(f_dpi)$p > 0.05)
(ncvTest(f_ddpi)$p > 0.05)


