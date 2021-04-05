# HOMEWORK - DISCRETE PROBABILITY DISTRIBUTIONS IN R (Lecture 1, task 2)
# Assume distribution given in data frame format
# row 1 - integer values
# row 2 - probabilities

# Define helper functions for breaking up tasks

# Mean of a distribution
dist_mean <- function(dist) {
  sum(dist[1,]*dist[2,])
}
# Variance of a distribution
dist_var <- function(dist) {
  mu <- dist_mean(dist) 
  sum((dist[1,]^2)*dist[2,])-mu^2
}
# Standard deviation of a distribution
dist_sigma <- function(dist) {
  sqrt(dist_var(dist))
}
# Since the problem definition demands EXCLUSIVE interval probabilities,
# two different ways of evaluating to avoid redundant lookups
interval_prob <- function(dist, a, b) {
  sum(dist[, dist[1,] > a & dist[1,] < b])
}
single_prob <- function(dist, x) {
  dist[2, dist[1,] == x]
}

# Single callable function that takes:
# dist - dataframe of a discrete probability distribution
# x - exact value for plotting a single probability
# a, b - interval bounds for getting interval probability
# .. and returns:
# mu - mean; var - variance; sigma - standard deviation, interval - probability
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

# Use on a uniform dieroll distribution
distrib <- t(rolldie(1,makespace = TRUE))
combined(distrib, 4, 1, 3)

# Use on a binomial coinflip distribution
n <- 10   # number of trials  (x axis upper limit)
k <- 0:n  # number of successes (x axis points)
p <- 0.5  # single trial probability (generates the binomial: coin flips etc)
distrib <- rbind(k,dbinom(k,n,p))
combined(distrib, 3, 2, 7)
