df <- read.delim("poverty.txt")
summary(df)
attach(df)
# what are the data types?
# - 1 col - states; others numeric
library(psych)
describe(PovPct)
boxplot(PovPct)
describe(Brth15to17)
boxplot(Brth15to17)
describe(Brth18to19)
boxplot(Brth18to19)
describe(ViolCrime)
boxplot(ViolCrime)
describe(TeenBrth)
boxplot(TeenBrth)
# c <- describe already contains the robust evals
library(robustbase)
mean(PovPct)
huberM(PovPct)$mu
mad(PovPct)
mean(Brth15to17)
huberM(Brth15to17)$mu
mad(Brth15to17)
mean(Brth18to19)
huberM(Brth18to19)$mu
mad(Brth18to19)
mean(ViolCrime)
huberM(ViolCrime)$mu
mad(ViolCrime)
mean(TeenBrth)
huberM(TeenBrth)$mu
mad(TeenBrth)
#d histogram - let crossvladiator select bins
library(histogram)
hh<-histogram(PovPct,type="regular",penalty="cv")
lines(density(PovPct,bw="ucv"),col="red",lwd=2)
hh<-histogram(Brth15to17,type="regular",penalty="cv")
lines(density(Brth15to17,bw="ucv"),col="red",lwd=2)
hh<-histogram(Brth18to19,type="regular",penalty="cv")
lines(density(Brth18to19,bw="ucv"),col="red",lwd=2)
hh<-histogram(ViolCrime,type="regular",penalty="cv")
lines(density(ViolCrime,bw="ucv"),col="red",lwd=2)
hh<-histogram(TeenBrth,type="regular",penalty="cv")
lines(density(TeenBrth,bw="ucv"),col="red",lwd=2)
# e normality
library(nortest)
# is it normally distributed?
(lillie.test(PovPct)$p > 0.05)
(lillie.test(Brth15to17)$p > 0.05)
(lillie.test(Brth18to19)$p > 0.05)
(lillie.test(ViolCrime)$p > 0.05)
(lillie.test(TeenBrth)$p > 0.05)
# bootstrap skewness
library(boot)
library(e1071)
cb_skewness <- function(x, i){
  skewness(x[i])
}
N<-10000
bobj_skew <- boot(PovPct,statistic=cb_skewness,R=N)
boot.ci(bobj_skew)
bobj_skew <- boot(Brth15to17,statistic=cb_skewness,R=N)
boot.ci(bobj_skew)
bobj_skew <- boot(Brth18to19,statistic=cb_skewness,R=N)
boot.ci(bobj_skew)
bobj_skew <- boot(ViolCrime,statistic=cb_skewness,R=N)
boot.ci(bobj_skew)
bobj_skew <- boot(TeenBrth,statistic=cb_skewness,R=N)
boot.ci(bobj_skew)
#f correlations between all cols
df1 <- df[c("PovPct","Brth15to17","Brth18to19","ViolCrime","TeenBrth")]
cor(df1)[1,]
cor(df1, method="spearman")[1,]
# is cor significant?
x<-cor.test(PovPct,Brth15to17)
(x$p.value < 0.05)
x$conf.int[1:2]
x<-cor.test(PovPct,Brth18to19)
(x$p.value < 0.05)
x$conf.int[1:2]
x<-cor.test(PovPct,ViolCrime)
(x$p.value < 0.05)
x$conf.int[1:2]
x<-cor.test(PovPct,TeenBrth)
(x$p.value < 0.05)
x$conf.int[1:2]
# linear regression
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
general_lreg(Brth15to17,PovPct,plot=T)
general_lreg(Brth18to19,PovPct,plot=T)
# multireg - explains about 50% of the variance, 15to17 more significant
fit_multi<-lm(PovPct~Brth15to17+Brth18to19, data=df1)
summary(fit_multi)
# multireg - all
fit_multi<-lm(PovPct~., data=df1)
summary(fit_multi)
# robut regs, outliers
fit<-lmrob(PovPct~Brth15to17,data=df1)
summary(fit)
fit<-lmrob(PovPct~Brth18to19,data=df1)
summary(fit)



fit<-lmrob(PovPct~Brth15to17,data=df1)
plot(Brth15to17,PovPct,col="grey")
summary(fit)
cbind(coef(fit),confint(fit, level = 0.95))
abline(fit,col="green",lwd=2,lty=2)
plot(fit)


library(np)
bw <- npregbw(PovPct~Brth15to17,regtype="ll")
n <- npreg(bw,residuals=T)
plot(Brth15to17,PovPct,col="grey")
lines(n$mean,col="red",lwd=2)