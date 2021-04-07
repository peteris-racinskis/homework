# Homework 2 - sampling distributions
# task 1: generate random 2, 10, 50 samples from: 
# chisquare(k=1);
# uniform(-1:1)
# Lognorm(1,1)
# task 2: compute the means of the samples
# task 3: compute the mean of each sample size and function 1000 times;
# calculate theoretic asymptotic sampling (mean) distribution from formula for each
# draw and see how close

# To avoid repeating code, iteration is abstracted using callbacks
nsize_repeat <- function(nsizes, params, times) {
  sapply(nsizes, function(i) {
    params$n <- i
    sapply(1:times, function(j) mean(params$cb(params)))
  })
}
# Callbacks for each type of distribution
chi_callback <- function(params) {
  rchisq(params$n, params$df)
}
exp_callback <- function(params) {
  rexp(params$n, params$rate)
}
uni_callback <- function(params) {
  runif(params$n, params$min, params$max)
}
lnm_callback <- function(params) {
  rlnorm(params$n, params$meanlog, params$sdlog)
}
# Sample parameters for each distribution
config = list(
  chi=list(cb=chi_callback,df=1),
  exp=list(cb=exp_callback,rate=1),
  uni=list(cb=uni_callback,min=-1,max=1),
  lnm=list(cb=lnm_callback,meanlog=1,sdlog=1)
)
nsizes = c(2,10,50)
# Getting one result
times = 20
lapply(config, function(i) nsize_repeat(nsizes, i, times))
# Getting 1000 results
times = 1000
results <- lapply(config, function(i) nsize_repeat(nsizes, i, times))

# NOTE: THE TASK HAS A FORMULA THAT USES VARIANCE, WHILE R TAKES DEVIATION!!!!
# Nowhere does it fucking say that the formula uses variance
# had to figure it out myself.
compare <- function(arg, data, mu, var, nvals, name) {
  sapply(1:length(nvals), function(i) {
    y <- dnorm(arg, mu, sqrt(var*nvals[i]))
    hist(data[,i],freq=FALSE,breaks=50,main=paste(name,1/nvals[i]))
    lines(arg,y)
    print('\n')
  })
}

ns <- c(1/2, 1/10, 1/50)
# Chi
xax <- seq(0,3,0.01)
compare(xax,results$chi,1,2,ns,"Chi square n = ")
# Exp: mean = 1/rate; variance = 1/rate^2; Theoretical: N(1/rate, (1/rate)^2/n)
# mean = 1/1 = 1; var = 1/1 = 1; N(1, sqrt(1/n))
compare(xax,results$exp,1,1,ns,"Exponential n = ")
# Uni
xax <- seq(-1,1,0.01)
compare(xax,results$uni,0,1/3,ns,"Uni n = ")
# Lnorm
lnm_mean <- exp(1+1/2)
lnm_var <- (exp(1) - 1) * exp(3)
xax <- seq(0,10,0.01)
compare(xax,results$lnm,lnm_mean,lnm_var,ns,"Lnorm n = ")

# Is 100 enough?
nsizes <- c(100)
ns <- c(1/100)
times <- 1000
new_data <- lapply(config, function(i) nsize_repeat(nsizes, i, times))
xax <- seq(0,3,0.01)
compare(xax,new_data$chi,1,2,ns,"Chi square n = ")
compare(xax,new_data$exp,1,1,ns,"Exponential n = ")
xax <- seq(-1,1,0.01)
compare(xax,new_data$uni,0,1/3,ns,"Uni n = ")
# Lnorm
xax <- seq(0,10,0.01)
compare(xax,new_data$lnm,lnm_mean,lnm_var,ns,"Lnorm n = ")


# THEORETICAL VALUES:
# Chi: mean = k; variance = 2k; Theoretical: N(k, 2k/n)
# k = 1; var = 2; N(1, sqrt(2/n))
ns <- c(1/2, 1/10, 1/50)
xax = seq(0,3,0.01)
y <- dnorm(xax, 1, sqrt(2/2))
hist(results$chi[,1],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, 1, sqrt(2/10))
hist(results$chi[,2],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, 1, sqrt(2/50))
hist(results$chi[,3],freq=FALSE,breaks=100)
lines(xax,y)
# Exp: mean = 1/rate; variance = 1/rate^2; Theoretical: N(1/rate, (1/rate)^2/n)
# mean = 1/1 = 1; var = 1/1 = 1; N(1, sqrt(1/n))
y <- dnorm(xax, 1, sqrt(1/2))
hist(results$exp[,1],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, 1, sqrt(1/10))
hist(results$exp[,2],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, 1, sqrt(1/50))
hist(results$exp[,3],freq=FALSE,breaks=100)
lines(xax,y)
# Uni: mean = (max-min)/2; variance = 1/12(max-min)^2; Th: N(mean, var/n)
# mean = 0; var = 1/3; N(1, sqrt(1/3n))
xax = seq(-1,1,0.01)
y <- dnorm(xax, 0, sqrt(1/6))
hist(results$uni[,1],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, 0, sqrt(1/30))
hist(results$uni[,2],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, 0, sqrt(1/150))
hist(results$uni[,3],freq=FALSE,breaks=100)
lines(xax,y)
# Lnm(mu, sig)
# mean: exp[mu + sig^2/n] = exp[1+1/n]
# var (exp[sig^2]-1)*exp[2*mu+sig^2] = (exp[1]-1) * exp[2 * 1 + 1)]
lnm_mean <- exp(1+1/2)
lnm_var <- (exp(1) - 1) * exp(3)
# mean = 1; variance = 1; sd = 1; N(1, sqrt(1/n))
xax = seq(0,10,0.01)
y <- dnorm(xax, lnm_mean, sqrt(lnm_var/2))
hist(results$lnm[,1],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, lnm_mean, sqrt(lnm_var/10))
hist(results$lnm[,2],freq=FALSE,breaks=100)
lines(xax,y)
y <- dnorm(xax, lnm_mean, sqrt(lnm_var/50))
hist(results$lnm[,3],freq=FALSE,breaks=100)
lines(xax,y)

# Is 100 enough?
nsizes <- c(100)
times <- 1000
new_data <- lapply(config, function(i) nsize_repeat(nsizes, i, times))
# chi
xax = seq(0,3,0.01)
y <- dnorm(xax, 1, sqrt(2/100))
hist(new_data$chi[,1],freq=FALSE,breaks=100)
lines(xax,y)
# exp
y <- dnorm(xax, 1, sqrt(1/100))
hist(new_data$exp[,1],freq=FALSE,breaks=100)
lines(xax,y)
# uni
xax = seq(-1,1,0.01)
y <- dnorm(xax, 0, sqrt(1/300))
hist(new_data$uni[,1],freq=FALSE,breaks=100)
lines(xax,y)
# lnm
xax = seq(0,10,0.01)
y <- dnorm(xax, lnm_mean, sqrt(lnm_var/100))
hist(new_data$lnm[,1],freq=FALSE,breaks=100)
lines(xax,y)

