# hypothesis testing
# read in data
df <- read.csv("anorex.csv")[,2:4]
attach(df)
# homework task:
# a) describe data
# - weight before CBT
# - weight after CBT 
# - weight delta
# b) explain why null hypothesis is important
# Null hypothesis: mu of delta = 0, there is no weight change
# H!: mu > 0
# no sd specified, needs to be estimated using t-test
# Because default assumption that any treatment method does not work
# Might waste time and resources on inefficient method 
# c) compute statistics, critical and acceptance region, p-value
# T-value: how many T-deviations from mean on T-distrib the mean of data is
# statistic T - T(x1,x2,...,xn)
# test power : P(h0 rejected | h1 is true)
# alternatively: P(X > critical value | h1 is true)
n <- length(change)
mu0 <- 0
X <- mean(change)
S <- sd(change)
# formula for empirical T-value given mu0, mean(data), sd(data) and n
# this tells us how far from the mean X sits on the t-distrib
tt <- sqrt(n)*(X - mu0)/S
# critical value
alpha <- 0.05
c <- 1-alpha
# limit for accepting hypothesis
cutoff <- qt(c,n-1)
cutoff
# calculate p-value of tt
pval <- pt(tt,n-1,lower.tail=F)
pval
# using built-in package stats
library(stats)
res <- t.test(change,alternative="greater",conf.level=0.95,mu=0)
res$statistic
conclusion <- (res$p.value < 0.05)
# d) draw graph with t-test density func, draw vertical lines for 
# critical value and p-value
# plot the t-distribution for df=n-1
xax <- seq(-3,3,0.1)
plot(xax,dt(xax,n-1),type="l")
abline(v=tt,col="red")
abline(h=0,lty=2)
abline(v=cutoff,col="green")
# e) reject null hypothesis? accept H1?
# at p = 0.05:
conclusion
# f) can Wilcox test be used?
# A: yes
# do the p-values differ a lot?
wilcox.test(before,after,alternative="l",paired=T,exact=F)
# A: not greatly - ~1% for t-test and ~3% for wilcox
# t-test is better for normally distributed data but not by a huge amount.
#  t-test is still robust under non-normal dist but might not be optimal
#  t-test is not very robust under asymmetric data
# Can test normality with shapiro test.
# Wilcox is good for determining symmetry. Not a good test for asymmetric
#  distros.
# From lecture: Wilcox converges faster for laplace; so it might work better
#  for various non-normal distributions.

# !!!!!!!!!!!!!!!!!!! NORMALITY TESTS !!!!!!!!!!!!!!!!!!!!!!!
# Shapiro
# library(nortest)
# lillie.test <- use if need Kolmogorov-Smironov test; unknown params
#    (mu, sigma)
