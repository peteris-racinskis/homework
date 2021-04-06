# read in data
df <- read.csv('cleaned.csv')
attach(df)
df <- df[order(Depth),]
# tasks:
# a) why compare wet/dry drill times?
# To find out if we can drill faster by using dry drilling
# b) construct SCATTERPLOT mean drill time vs depth
# - do drill times depend on depth?
# - in what depth range?
# - consider reasons why
# c) construct boxplots for wet and dry drilling
#    get descriptive statistics
#    compare both samples
#    construct q-q plot
#    are dispersions the same?
# d) using 2-sample t-test compare both samples
#    compare p-values, assuming disepersions are same
#    compare p-values assuming dispersions are NOT same
#    should we expect dispersions to be the same?
#    ceheck dispersion equality with var.test
#    compare both samples when depth doesn't affect time
# e) find confidence interval for difference between means
#    does diff = 0 lie within 95% confidence interval?
#    do we reject hypothesis diff = 0?