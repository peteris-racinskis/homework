### Ielasam datus un apskatamies histogrammu
dati<-scan(file="dati.txt")
hist(dati,prob=T,ylim=c(0,0.6))
hist(dati,prob=T,ylim=c(0,0.6),breaks=50)
length(dati)

## Kodolu blīvuma funkcijas gludinātājs
lines(density(dati),col="red",lwd=2) # rule-of-thumb
lines(density(dati,bw="ucv"),col="blue",lwd=2) 
# Krosvalidācijas metode

plot(density(dati,bw="ucv"),col="blue",lwd=2) 

#### Kodolu novērtētājs
K<-function(x) 1/sqrt(2*pi)*exp(-x^2/2) # N(0,1) blīvuma funcija
integrate(K,-Inf,Inf)

kod.fun<-function(x,x.dati,h)
{
n<-length(x.dati)
1/n/h * sum(K((x-x.dati)/h))
}
kod.fun<-Vectorize(kod.fun,vectorize.args="x")

x<-seq(-5,5,by=0.01)
hist(dati,prob=T,ylim=c(0,0.6),breaks=50)
h<-1 # pārgludināts
lines(x,kod.fun(x,dati,h),col="green")
h<-0.01 # nenogludināts
lines(x,kod.fun(x,dati,h),col="red")
h<-bw.ucv(dati);h
lines(x,kod.fun(x,dati,h),col="blue",lwd=2)

### Kodolu izvēle nav tik svarīga
hist(dati,prob=T,ylim=c(0,0.6),breaks=50)
lines(density(dati,bw="ucv",kernel = c("gaussian")),
      col="blue",lwd=2) 
lines(density(dati,bw="ucv",kernel = c("epanechnikov")),
      col="red",lwd=2) 
lines(density(dati,bw="ucv",kernel = c("biweight")),
      col="brown",lwd=2) 

### Dažādās joslas platuma novērtēšanas metodes
bw.ucv(dati);bw.bcv(dati);bw.nrd0(dati);bw.nrd(dati);bw.SJ(dati)

### Neparametriskā kodolu Nadaraya-Watson regresija
x.dati<-cars$speed
y.dati<-cars$dist
plot(x.dati,y.dati)
fit<-lm(y.dati~x.dati)
summary(fit)
abline(fit)

# N-W neparametriskā regresija
nw.fun<-function(x,x.dati,y.dati,h)
{
  sum(K((x-x.dati)/h)*y.dati)/sum(K((x-x.dati)/h))
}
nw.fun<-Vectorize(nw.fun,vectorize.args="x")
x<-seq(0,25,by=0.01)
plot(x.dati,y.dati)
h<-1.6
lines(x,nw.fun(x,x.dati,y.dati,h),col="blue")

## optimālais joslas platums
library(KernSmooth)
dpill(x.dati,y.dati) # plug-in metode






######################  Krosvalidācijas metode regresijai: tiks pārbaudīta
library(PLRModels)
n<-length(x.dati)
dd<-matrix(c(x.dati,y.dati),nrow=n)
np.cv(dd)$CV.opt # pašlaik īsti nstrādā


set.seed(1234)
# We generate the data
n <- 100
t <- ((1:n)-0.5)/n
m <- function(t) {0.25*t*(1-t)}
f <- m(t)

epsilon <- rnorm(n, 0, 0.01)
y <-  f + epsilon
data_ind <- matrix(c(y,t),nrow=100)

# We apply the function
a <-np.cv(data_ind)
a$CV.opt






























