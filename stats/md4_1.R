# practice
smp <- rnorm(2000,0,1)
# define a max likelihood func
# theta |-> f_theta(x) <- do for each x
# map theta values to f_theta(x)
# theta for N: (mu, sigma)
# FOR A NORMAL DISTRIBUTION: maximum likelihood estimate is 
# the same as simply calculating the mean and sd from the data!
# https://towardsdatascience.com/maximum-likelihood-estimation-explained-normal-distribution-6207b322e47f

# MOMENT METHOD ESTIMATION: get moments like mean, sd, construct distro
# No optimization step required, same as moment method

llf_norm <- function(param) {
  mu <- param[1]
  sd <- param[2]
  x  <- q_data$stations
  llValue <- dnorm(x, mean=mu, sd=sd, log=TRUE) # log true gives log(prob)
  sum(llValue)
}
mlnorm <- 
res <- mmme_norm(smp)
hist(smp,prob=T)
xax <- seq(min(smp),max(smp),0.01)
lines(xax,dnorm(xax,res$mu,res$sd))

q_data <- quakes
# moment method for lnorm <- formulas from internet
norm_pdf <- function(x,mu,sigma) {
  dnorm(x,mu,sigma)
}
lnorm_pdf <-function(x,mu,sigma)
{
  location <- log(mu^2 / sqrt(sigma^2 + mu^2))
  shape <- sqrt(log(1 + (sigma^2 / mu^2)))
  dlnorm(x,location,shape)
}
# moment method for exp <- rate = 1/mean <-> mean = 1/rate
exp_pdf <- function(x,mu) {
  dexp(x,1/mu)
}
hist(q_data$stations,prob=T,main="MME for exp and lnorm")
xax <- seq(0,max(q_data$stations),0.1)
x <- q_data$stations
lines(xax,norm_pdf(xax,mean(x),sd(x)),col="blue")
lines(xax,lnorm_pdf(xax,mean(x),sd(x)),col="red")
lines(xax,exp_pdf(xax,mean(x)),col="green")
# which is good? lornm and exp look good - lnorm looks closer in the lower reg
# exp looks like it follows shape beteter 


# MAX LIKELIHOOD ESTIMATION: 
# 1) find pdf(x)
# 2) find log(pdf(x))
# 3) maximize log(pdf(x)) with respect to theta <- (mu, sigma)
library(maxLik)
# for lnorm: lnorm already is the log-likelihood, mu sigma are for the log
# for optimizer to work function needs to take vector of params
# for optimizer the function spits out the sum over {x1, x2, ..., xn}
llf_norm <- function(param) {
  mu <- param[1]
  sd <- param[2]
  x  <- q_data$stations
  llValue <- dnorm(x, mean=mu, sd=sd, log=TRUE) # log true gives log(prob)
  sum(llValue)
}
llf_lnorm <- function(param) {
  mu <- param[1]
  sd <- param[2]
  x <- q_data$stations
  # get the pd for each x given the distro params lnm(x | (mu,sigma))
  llValue <- dlnorm(x, mean=mu, sd=sd, log=TRUE) # log true gives log(prob)
  sum(llValue)
}
llf_exp <- function(param) {
  lambda <- param[1]
  x <- q_data$stations
  n <- length(x)
  n*log(lambda)-lambda*sum(x)
}

# run through an optimizer (lnorm)
mu_init = 3.5
sd_init = 0.6
mlnrm <- maxLik(llf_norm,  start=c(mu_init,sd_init))
summary(mlnrm)
mllnm <- maxLik(llf_lnorm, start=c(mu_init,sd_init))
summary(mllnm)
lambda_init <- 1/20
mlexp <- maxLik(llf_exp, start=c(lambda_init))
summary(mlexp)
hist(q_data$stations,prob=T,main="MLE for norm, lnorm and exp")
xax <- seq(0,max(q_data$stations),0.1)
lines(xax,dnorm(xax,mlnrm$estimate[1],mlnrm$estimate[2]),col="blue")
lines(xax,dlnorm(xax,mllnm$estimate[1],mllnm$estimate[2]),col="red")
lines(xax,dexp(xax,mlexp$estimate[1]),col="green")

# which is better?
# lnorm looks significantly better in the bottom half but shape is wrong
# exp shape looks better but undershoots near the start

