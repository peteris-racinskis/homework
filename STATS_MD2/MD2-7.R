#md 7 bootstrap
# 1. import data
df <- InsectSprays
attach(df)
# 2. find confidence intervals with bootstrap for:
library(boot)
hist(count)
# - mean
cb_mean <- function(x, i){
  mean(x[i])
}
bootobject <- boot(count,statistic=cb_mean,R=10000)
boot.ci(bootobject)
# - median
cb_median <- function(x, i){
  median(x[i])
}
bootobject <- boot(count,statistic=cb_median,R=10000)
boot.ci(bootobject)
# - skewness
library(e1071)
cb_skewness <- function(x, i){
  skewness(x[i])
}
bootobject <- boot(count,statistic=cb_skewness,R=10000)
boot.ci(bootobject)
#  compare to t-test, wilcox
t.test(count,mu=mean(count))
wilcox.test(count,conf.int = T)
# 3. evaluate location parameter ROBUSTLY using median, trimmed mean,
#     Huber M-score. Are ROBUST measures very different from mean?
mean(count)
median(count)
mean(count,trim=0.2)
huberM(count)$mu


# bootstrap trimmed mean
cb_trim<-function(x,i){
  mean(x[i],trim=0.2)
}
bootobject <- boot(count,statistic=cb_median,R=10000)
boot.ci(bootobject)
# copy paste t-test formula, replace mean<-median, sd<-mad

# t-test for trimmed means (yuen test)
library(DescTools)
YuenTTest(count)
# Contaminated model
