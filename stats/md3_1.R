# use data "quakes"
# a) describe what the variable columns mean
# b) construct boxplots, describe
summary(quakes)
attach(quakes)
# variables:
# - lat, long - latitude, longitude (should be uniform)
# - depth - how deep under surface? (might be normal?)
# - mag - richter magnitude (should be exp or lognormal)
# - stations - how many stations reported the event (same)
# outlier - data point outside whiskers
# default value of whiskers - 1.5 * IQR (Q2+Q3 width)
# outlier - a data point in Q1 or Q4 is farther from the box than that
# this means the distribution has thick part and long tails
boxplot(lat)
summary(lat)
hist(lat)
boxplot(long)
summary(long)
hist(long)
boxplot(depth)
summary(depth)
hist(depth)
boxplot(mag)
summary(mag)
hist(mag)
boxplot(stations,)
summary(stations)
hist(stations)
boxplot(lat,main="lat")
# data with lots of outliers: 
# 1) lat - seems to have an artificial cutoff on one side due to cube
# 2) long - multimodal distribution with another peak on one side
# 3) magnitude - has a hard cutoff and likely an exponential/lognormal distro
# 4) stations - exponential distribution, one very long tail for bigger events
