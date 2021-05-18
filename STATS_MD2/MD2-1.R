# MD 1
# 1. Read CMB data into file
df <- read.table('CMB.dat',header=TRUE)
attach(df)
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
# Data: col1 (ell) - multiple moment
#       clo2 (Cl)  - spectrum deviation
# 2. Perform:
# - Linear regression
fit1 <- general_lreg(ell,Cl,plot=T,print=T)
# 3. Perform: polynomial regression
#   - Check best fit polynomial order with ANOVA
# This should get tail call optimized by the compiler so don't
# sweat the recursion. It won't expand on the stack.
bestfit <- function(vec1,vec2,deg=1,last_deg=1,P=0,p=0.05,max=27) {
  if((P>0.05) || (deg>max)){
    list(d=last_deg,p=P)
  } else {
    f1<-general_lreg(vec1,vec2,deg)
    next_deg<-deg+2
    f2<-general_lreg(vec1,vec2,next_deg)
    P<-anova(f1,f2)$'Pr(>F)'[2]
    bestfit(vec1,vec2,next_deg,deg,P)
  }
}
res <- bestfit(ell,Cl)
paste("stopped at x^", res$d,sep="")
paste("p value:",res$p)
fitmax<-general_lreg(ell,Cl,degree=res$d,plot=T,print=T)
# 4. Perform residual analysis like in lecture
#   - independence (are residuals random, uncorrelated with data?)
plot(ell,fit1$residuals)
plot(ell,fitmax$residuals)
#   - autocorrelation (is residual independent of previous residual?)
#       durbinWatsonTest() <- from time series analysis
library(car)
durbinWatsonTest(fit1)
durbinWatsonTest(fitmax)
#   - normality
#       - qqnorm
#       - qqline
#       - shapiro.test()
qqnorm(fit1$residuals)
qqline(fit1$residuals)
qqnorm(fitmax$residuals)
qqline(fitmax$residuals)
library(nortest)
# degree-1 approximation normality
(lillie.test(fit1$residuals)$p.value > 0.05)
# max degree approximation normality
(lillie.test(fitmax$residuals)$p.value > 0.05)
#   - homoscedasticity
#       -ncvTest() <- reject hypothesis of constant variance
(ncvTest(fit1)$p > 0.05)
(ncvTest(fitmax)$p > 0.05)





# OLD GENERAL_LREG FUNCTION
general_lreg <- function(vec1,vec2,degree=1,plot=F,print=F) {
  fit<-lm(vec2~poly(vec1,degree,raw=T)) 
  if(plot){
    plot(vec1,vec2)
    x <- seq(min(vec1),max(vec1),length.out = length(vec1))
    f <- predict(fit, newdata = data.frame(vec1 = x))
    lines(x,f,col="red",lwd=2)
  }
  if(print){
    print(summary(fit))
  }
  fit
}






