# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# START OF HM1_1
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!
library(prob)
# rep(x, times=n) - returns vector of n values of type and value same as x
p <- rep(1/6, times=6)
# probspace(<outcomes>, <probabilities>) Generate a probability space from vecs
# R treats probspace as a vector or probability values 
# associated with a set of outcome objects.
dice <- probspace(1:6, probs=p)
dice
A <- subset(dice, x == 1)
B <- subset(dice, x == 2)
Prob(subset(dice, x == 1))
Prob(union(A,B))
# c(something) returns a vector
roll3 <- iidspace(c(1:6), ntrials = 3, probs = p)
# R uses SINGLE AMPERSAND - AND is & !!!!!!!!
C <- subset(roll3, X1+X2+X3 >= 7 & X1+X2+X3 <= 10)
#D <- subset(roll3, X1+X2+X3 < 11)
#Prob(intersect(C,D))
C
Prob(C)

# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# END OF HM1_1
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!




# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# START OF HM1_2
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# given - discrete random variable with probability distribution
# format: vector of values, vector of probabilities

# Function definition:
# inputs: X = distribution, a = constant, b = constant, c = constant
# outputs: E[X], Var[X], s[X], draw P(X=c) as a line, P(a < X < b), draw p(x)
n <- 10    # number of trials  (x axis upper limit)
k <- 0:n  # number of successes (x axis points)
p <- 0.5  # single trial probability (generates the binomial: coin flips etc)
# 10 rolls - 11 possible values (can also have 0 !!!)
probs = dbinom(k,n,p)
cumsum(probs)
probs     # just a vector of probabilities - NO ASSOCIATED VALUE!
plot(k,probs) # NEED TO ASSOCIATE VALUES WITH X
distrib <- rbind(k,probs)
distrib
distrib[1,]       # values of random variable X
distrib[2,c(1:5)] # P(X=x)
plot(distrib[1,],distrib[2,])
dist_mean <- function(dist) {
  # dist - frame with 2 rows
  # row 1 - values X = x
  # row 2 - probs P(X=x)
  sum(dist[1,]*dist[2,])
}
dist_var <- function(dist) {
  mu <- dist_mean(dist)                 # mean
  n <- length(dist[1,])               # degrees of freedom
  sum((dist[1,]^2)*dist[2,])-mu^2     # variance formula 
  #(NO DIVISION! NOT EMPIRICAL!)
}
dist_sigma <- function(dist) {
  sqrt(dist_var(dist))
}
# Needs a separate function because the problem definition
# uses < and > rather than <= and >=.
interval_prob <- function(dist, a, b) {
  sum(dist[, dist[1,] > a & dist[1,] < b])
}
single_prob <- function(dist, x) {
  dist[2, dist[1,] == x]
}
combined <- function(dist, x, a, b) {
  plot(dist[1,],
       dist[2,],
       type="b",
       xlab="x",
       ylab="P(X=x)")
  flatline <- rep(single_prob(dist,x),times=length(dist[1,]))
  lines(dist[1,],flatline)
  list(mu=dist_mean(dist),
       var=dist_var(dist),
       sig=dist_sigma(dist),
       interval=interval_prob(dist,a,b))
}
combined(distrib,7,2,9)
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# END OF HM1_2
# !!!!!!!!!!!!
# !!!!!!!!!!!!
# !!!!!!!!!!!!