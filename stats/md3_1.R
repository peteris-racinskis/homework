# use data "quakes"
# a) describe what the variable columns mean
# b) construct boxplots, describe
q_data <- quakes
summary(q_data)
# variables:
# - lat, long - latitude, longitude (should be uniform)
# - depth - how deep under surface? (might be normal?)
# - mag - richter magnitude (should be exp or lognormal)
# - stations - how many stations reported the event (same)
# outlier - data point outside whiskers
# default value of whiskers - 1.5 * IQR (Q2+Q3 width)
# outlier - a data point in Q1 or Q4 is farther from the box than that
# this means the distribution has thick part and long tails
boxplot(q_data$lat)
summary(q_data$lat)
hist(q_data$lat)
boxplot(q_data$long)
summary(q_data$long)
hist(q_data$long)
boxplot(q_data$depth)
summary(q_data$depth)
hist(q_data$depth)
boxplot(q_data$mag)
summary(q_data$mag)
hist(q_data$mag)
boxplot(q_data$stations)
summary(q_data$stations)
hist(q_data$stations)
# data with lots of outliers: 
# 1) lat - seems to have an artificial cutoff on one side due to cube
# 2) long - multimodal distribution with another peak on one side
# 3) magnitude - has a hard cutoff and likely an exponential/lognormal distro
# 4) stations - exponential distribution, one very long tail for bigger events
