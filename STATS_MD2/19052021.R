### Datu pārkārtošanas metodes
### Butstrapa metode

dati<-scan(file="nerve.txt")
length(dati)
library(histogram)

hist(dati,prob=T,breaks=40)
x<-seq(0,1.4,by=0.001)
lines(x,dexp(x,1/mean(dati)),col="blue",lwd=2)
#histogram(dati,type="regular",penalty="cv")
boxplot(dati)

# 1) ticamības intervāli vidējai vērtībai
t.test(dati) # dati nav normāli sadalīti, īsti lietot nevajadzētu

# procentīļu butstraps
N<-10000
rez<-replicate(N,mean(sample(dati,replace=T)))
alpha<-0.05
quantile(rez,alpha/2)
quantile(rez,1-alpha/2)
# sample(1:10,replace=T)

# 2) ticamības intervāli mediānai
rez<-replicate(N,median(sample(dati,replace=T)))
alpha<-0.05
quantile(rez,alpha/2)
quantile(rez,1-alpha/2)

# 3) ticamības intervāli asimetrijas koeficientam (skewness)
rez<-replicate(N,skewness(sample(dati,replace=T)))
alpha<-0.05
quantile(rez,alpha/2)
quantile(rez,1-alpha/2)

# 0 nepieder ticamības intervālam, tad simetrijas datos nav!

library(boot)
samp_mean <- function(x, i) {
  skewness(x[i])
}

bootobject <- boot(dati, statistic=samp_mean, R=10000) 
boot.ci(bootobject, conf=0.95)


#### Butstrapa metode dispersijai izlases vidējai vērtībai
set.seed(1)
dati<-rexp(100,1) # vid.vert=1 un disp=1
mean(dati) 

# Ticamības intervāli vidējai vērtībai?
rez<-replicate(N,mean(sample(dati,replace=T)))
var(rez) # butstrapa dispersijas aproksimācija
1/100 # īstā dispersija

# Normal bootstrap intervals
mean(dati)-qnorm(1-alpha/2)*sd(rez)
mean(dati)+qnorm(1-alpha/2)*sd(rez)

# Procentīļu intervāli
rez<-replicate(N,mean(sample(dati,replace=T)))
alpha<-0.05
quantile(rez,alpha/2)
quantile(rez,1-alpha/2)

samp_mean <- function(x, i) {
  mean(x[i])
}
bootobject <- boot(dati, statistic=samp_mean, R=10000) 
boot.ci(bootobject, conf=0.95)


###### t-tests cars datiem
hist(cars$speed)
t.test(cars$speed)$conf.int

samp_mean <- function(x, i) {
  mean(x[i])
}
bootobject <- boot(cars$speed, statistic=samp_mean, R=10000) 
boot.ci(bootobject, conf=0.95)


##### Statistikas sadalījuma aproksimācija
set.seed(1)
n<-100
dati<-rexp(n,1) # vid.vert=1 un disp=1
mean(dati) 

rez<-replicate(N,mean(sample(dati,replace=T)))
hist(rez,prob=T) # butstrapotais izlases vid.vērt sadalījums

# teorētiskais (asimptotiskais sadalījums) no CRT
x<-seq(0,1.4,by=0.01)
lines(x,dnorm(x,1,sqrt(1/n)),col="blue")

#### Korekta sadalījuma bustrapošana
rez<-replicate(N,sqrt(n)*(mean(sample(dati,replace=T))-mean(dati))/sd(dati))
hist(rez,prob=T) # butstrapotais izlases vid.vērt sadalījums

x<-seq(-3,3,by=0.01)
lines(x,dnorm(x,0,1),col="blue")





























