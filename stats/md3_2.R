# use data "InsectSprays"
InsectSprays <- InsectSprays
summary(InsectSprays)
attach(InsectSprays)
library(psych)
# a) boxplot - number of bugs by spray type
boxplot(count~spray)
describe(count)
describe(count[spray=="A"])
describe(count[spray=="B"])
describe(count[spray=="C"])
describe(count[spray=="D"])
describe(count[spray=="E"])
describe(count[spray=="F"])
# b) which samples could be more similar?
# A,B,F; C,D,E
# c) use descriptive stats on samples
# d) check if samples normally distributed with:
#  - histogram
#  - quantile-quantile
#  - probability-probability
# e) compare similar pops qith q-q and p-p
boxplot(count~spray)
draw_near <- function(data) {
  h <- hist(data,prob=T)
  lines(density(data))
  xax <- seq(min(h$breaks),max(h$breaks),0.01)
  lines(xax,dnorm(xax,mean(data),sd(data)),col="red",lwd=2)
}
# histogram with equivalent normal distrib
draw_near(count[spray=="A"])
draw_near(count[spray=="B"])
draw_near(count[spray=="C"])
draw_near(count[spray=="D"])
draw_near(count[spray=="E"])
draw_near(count[spray=="F"])
qqnorm(count[spray=="A"])
qqline(count[spray=="A"])
qqnorm(count[spray=="B"])
qqline(count[spray=="B"])

# compare mutually similar
boxplot(count[spray=="A"|spray=="B"]~spray)
qqplot(count[spray=="A"],count[spray=="B"])
abline(0,1,col="red")
qqplot(count[spray=="A"],count[spray=="F"])
abline(0,1,col="red")
qqplot(count[spray=="B"],count[spray=="F"])
abline(0,1,col="red")
qqplot(count[spray=="C"],count[spray=="D"])
abline(0,1,col="red")
qqplot(count[spray=="C"],count[spray=="E"])
abline(0,1,col="red")
qqplot(count[spray=="D"],count[spray=="E"])
hist(count[spray=="B"])
hist(count[spray=="C"])
hist(count[spray=="D"])
hist(count[spray=="E"])

# Normal P-P plot of Normal data
g1 <- ggplot(data = subset(InsectSprays,spray=="A"), mapping = aes(sample = count)) +
  stat_pp_band(colour="blue") +
  stat_pp_line() +
  stat_pp_point()+
  labs(title="PP grafiks (A)", x = "Teorētiskās kvantiles", y = "Izlases kvantiles")

# Normal P-P plot of Normal data
g2 <- ggplot(data = subset(InsectSprays,spray=="B"), mapping = aes(sample = count)) +
  stat_pp_band() +
  stat_pp_line() +
  stat_pp_point()+
  labs(title = "PP grafiks (B)", x = "Teorētiskās kvantiles", y = "Izlases kvantiles")

grid.arrange(g1,g2,ncol=2)


require(ggplot2)
require(qqplotr)
require(gridExtra)

plot_PP_norm <- function(data) {
  g <- ggplot(data = data, mapping = aes(sample = count)) +
    stat_pp_band() +
    stat_pp_line() +
    stat_pp_point()+
    labs(title = paste("P-P plot",data$spray[1]), x = "Theoretical", y = "Sample")
  g
}
plot_QQ_norm <- function(data) {
  g <- ggplot(data = data, mapping = aes(sample = count)) +
    stat_qq_band() +
    stat_qq_line() +
    stat_qq_point()+
    labs(title = paste("Q-Q plot",data$spray[1]), x = "Theoretical", y = "Sample")
  g
}
plots <- function(data) {
  print(plot_PP_norm(data))
  print(plot_QQ_norm(data))
}
compare_QQ <- function(d1,d2){
  x <- d1$count
  y <- d2$count
  sx <- sort(x)
  sy <- sort(y)
  lenx <- length(sx)
  leny <- length(sy)
  if (leny < lenx) sx <- approx(1L:lenx, sx, n = leny)$y
  if (leny > lenx) sy <- approx(1L:leny, sy, n = lenx)$y
  require(ggplot2)
  g = ggplot() + geom_point(aes(x=sx, y=sy))+
    geom_abline(intercept =0, slope = 1)+
    labs(title="QQ compare",x=d1$spray[1],y=d2$spray[1])
  g
}
compare_PP <- function(d1,d2,min_c,max_c) {
  x <- d1$count
  y <- d2$count
  fn1<-ecdf(x)
  fn2<-ecdf(y)
  xx<-seq(min_c,max_c,0.1)
  dd<-data.frame(y=fn1(xx),x=fn2(xx))
  g <- ggplot(dd, aes(x=x,y=y))+geom_point()+
    geom_abline(intercept =0, slope = 1)+
    labs(title="PP compare",x=d1$spray[1],y=d2$spray[1])
  g
}
compare_two <- function(d1,d2,min_c,max_c) {
  print(compare_PP(d1,d2,min_c,max_c))
  print(compare_QQ(d1,d2))
}
a <- subset(InsectSprays,spray=="A")
b <- subset(InsectSprays,spray=="B")
c <- subset(InsectSprays,spray=="C")
d <- subset(InsectSprays,spray=="D")
e <- subset(InsectSprays,spray=="E")
f <- subset(InsectSprays,spray=="F")
plots(a)
plots(b)
plots(c)
plots(d)
plots(e)
plots(f)
MIN <- min(InsectSprays$count)
MAX <- max(InsectSprays$count)
compare_two(a,b,MIN,MAX)
compare_two(a,f,MIN,MAX)
compare_two(b,f,MIN,MAX)
compare_two(c,d,MIN,MAX)
compare_two(c,e,MIN,MAX)
compare_two(d,e,MIN,MAX)