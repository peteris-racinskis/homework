# md6
# 1. Read CMB data
df <- read.table('CMB.dat',header=TRUE)
attach(df)
# 2. Do polynomial and nonparametric Nadaraya-Watson regression
# know from before that 9 is the best fit interpolator (probable overfit)
p <- lm(Cl~poly(ell,7,raw=T))
# Pure Nadaraya-Watson regression
library(np)
bw <- npregbw(Cl~ell,bwmethod="cv.ls",regtype="lc")
n <- npreg(bw,residuals=T)
# plot and compare
plot(ell,Cl,col="grey",ylim=c(-500,6000))
lines(n$mean,col="red",lwd=2)
lines(p$fitted.values,col="blue",lwd=2,lty="dotted")
# 3. Check conditions, do diagnostic
# Conditions for data checked before already, copy from task 1
acf(n$resid)
acf(p$residuals)


plot(ell,n$resid,col="grey",ylim=c(-1000,1000))
lines()
lines(p$fitted.values,col="blue",lwd=2,lty="dotted")
# 4. Draw conclusions
# Polynomial fits data somewhat better within the defition interval,
#   but is useless for making prediction
# 5. Evaluate bandwidth for the nonparametric reg., compare
# pure NW
npregbw(Cl~ell,bwmethod="cv.aic")
# local linear
bwll <- npregbw(Cl~ell,regtype="ll")
bwll
# plug-in
bwrt <- dpill(ell,Cl)
bwrt <-npregbw(Cl~ell,bws=bwrt,bandwidth.compute=F)
bwrtll <-npregbw(Cl~ell,regtype="ll",bws=bwrt,bandwidth.compute=F)
# do the regression
nll <- npreg(bwll,residuals=T)
nrt <-npreg(bwrt,residuals=T)
nrt <-npreg(bwrt,residuals=T)
nrtll <-npreg(bwrtll,residuals=T)
#plot
plot(ell,Cl,col="grey",ylim=c(-500,6000))
lines(n$mean,col="red")
lines(nll$mean,col="blue")
lines(nrt$mean,col="black")
lines(nrtll$mean,col="green")
# show that npreg does the same as locpoly
fit<-locpoly(ell,Cl,bandwidth=bwll$bw)
plot(ell,Cl,col="grey",ylim=c(-500,7000))
lines(nll$mean,col="black",lwd=6)
lines(fit,col="red",lwd=3)



library(testcorr)
res<-ac.test(n$resid,max.lag = 20,alpha = 0.05,table = F,plot = F)
ac.test(p$residuals,max.lag = 20)

bw <- npregbw(Cl~ell,bwmethod="cv.aic") # crossvalidated bw
bwll <- npregbw(Cl~ell,regtype="ll",bwmethod="cv.aic")
library(KernSmooth)
bwrt <- dpill(ell,Cl)
bwrt <- npregbw(Cl~ell,bandwidth.compute=F,bws=c(bwrt))
n <- npreg(bw,residuals=T)
nll <- npreg(bwll,residuals=T)
nrt <-npreg(bwrt,residuals=T)
p <- lm(Cl~poly(ell,7,raw=T))
plot(ell,Cl,col="grey",ylim=c(-500,6000))
lines(n$mean,col="red")
lines(nll$mean,col="blue")
lines(nrt$mean,col="black")
plot(ell,(n$mean-nrt$mean))
lines(p$fitted.values,col="blue")
plot(p$residuals,ylim=c(-2000,2000))
plot(n$resid-nrt$resid)
abline(h=0,lty="dotted",lwd=2,col="yellow")
points(nll$resid,col="red")
wilcox.test(nll$resid,n$resid)
plot(nrt$resid)
abline(h=0,lty="dotted",lwd=2,col="yellow")
plot(nll$resid,color="grey")
abline(h=0,lty="dotted",lwd=2,col="yellow")
x <- seq(min(ell),max(ell),length.out = length(ell))
n_p <- predict(n, newdata = data.frame(vec1 = ell))
p_p <- predict(p, newdata = data.frame(vec1 = x))
lines(x,n_p,col="red",lwd=3)
lines(x,p_p,col="blue",lwd=2,lty="dotted")
library(car)
plot(ell,Cl-n_p,col="grey")
r_dataframe <- as.data.frame(list(x=ell,residuals=n$resid))
durbinWatsonTest(r_dataframe)
p_copy$residuals <- n$resid
durbinWatsonTest(n_p)
durbinWatsonTest(p)
acf(n$resid)
acf(p$resid)

fit<-locpoly(ell,Cl,bandwidth=dpill(ell,Cl))
plot(fit)
plot(ell,Cl,col="grey",ylim=c(-500,7000))
lines(n$mean,col="red")
lines(nrt$mean,col="black")
plot(ell,(nrt$mean-fit$y))