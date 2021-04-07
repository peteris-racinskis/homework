# read in data
df <- read.csv('cleaned.csv')
attach(df)
# tasks:
# a) why compare wet/dry drill times?
# To find out if we can drill faster by using dry drilling
# b) construct SCATTERPLOT mean drill time vs depth
require(ggplot2)
require(gridExtra)
ap <- ggplot(data=df,aes(x=Depth, y=Wet))+ # create the ggplot object
  geom_point()                               # add drawable thing
bp <- ggplot(data=df,aes(x=Depth, y=Dry))+ # create the ggplot object
  geom_point()                               # add drawable thing
grid.arrange(ap,bp,ncol=2)
# - do drill times depend on depth?
# A: Not initially, but in deeper holes
# - in what depth range?
# A: After about 200m
# - consider reasons why
# A: might be hitting harder rock, other factors dominate early on.
# c) construct boxplots for wet and dry drilling
require(reshape)
md <- melt(df[,2:3])
g <- ggplot(data=md,aes(x=as.factor(variable),y=value)) +
  geom_boxplot()
g
#    get descriptive statistics
#    compare both samples
require(psych)
describe(Dry)
describe(Wet)
#    construct q-q plot
compare_QQ <- function(d,v1,v2){
  x <- subset(d, variable==v1)$value
  y <- subset(d, variable==v2)$value
  sx <- sort(x)
  sy <- sort(y)
  lenx <- length(sx)
  leny <- length(sy)
  if (leny < lenx) sx <- approx(1L:lenx, sx, n = leny)$y
  if (leny > lenx) sy <- approx(1L:leny, sy, n = lenx)$y
  require(ggplot2)
  g = ggplot() + geom_point(aes(x=sx, y=sy))+
    geom_abline(intercept =0, slope = 1)+
    labs(title="QQ compare",x=v1,y=v2)
  g
}
compare_QQ(melt(df[,2:3]),"Dry","Wet")
#    compare both samples
# A: Dry drilling is consistently faster than wet in the lower depth
#     region but the difference seems to even out around 1200m
#    Are variances the same? - important for testing!!!!!!
#     for paired test often assume variances equal
# A: Looking at box plots, the dry test seems to have a bigger variance,
#    but it's far from conclusive. Variances looks pretty similar
#    in the low depth region. Can't assume normally distributed
#    But might be close neough. See test results below.
# d) using 2-sample t-test compare both samples
#    compare p-values, assuming variances are same
t.test(Dry,Wet,alternative="two.sided",var.equal=T,conf.level=0.95)
#    compare p-values assuming Variances are NOT same
t.test(Dry,Wet,alternative="two.sided",var.equal=F,conf.level=0.95)
#    should we expect Variances to be the same?
# A: in the low depth region there is a reasonable expectation for having 
#    similar variances as the data look similar and it seems like external
#    factors dominate in determining drill time.
#    check Variance equality with var.test
dv <- var.test(Dry,Wet,conf.level=0.99); dv
conf <- 0.05
(dv$p.value < conf)
dv$p.value
dv$estimate
#    compare both samples when depth doesn't affect time
flat <- subset(df,Depth<200)
dv <- var.test(flat$Dry,flat$Wet,conf.level=0.95); dv
t.test(flat$Dry,flat$Wet,alternative="two.sided",var.equal=T,conf.level=0.95)
conf <- 0.05
(dv$p.value < conf)
dv$p.value
dv$estimate
# e) find confidence interval for difference between means
res <- t.test(Dry,Wet,
              alternative="two.sided",var.equal=T,conf.level=0.95)
i <- res$conf.int
i
#    does diff = 0 lie within 95% confidence interval?
(i[1] < 0 & i[2] > 0)
#    do we reject hypothesis diff = 0?
# A: yes, quite conclusively.
require(nortest)
# big number - normal
# small number - not normal
# reject or accept H0 - normality
lillie.test(flat$Dry)$p.value
lillie.test(Dry)$p.value
shapiro.test(flat$Dry)$p.value
shapiro.test(Dry)$p.value
lillie.test(rnorm(1000,0,1))
