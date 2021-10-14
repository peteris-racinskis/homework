dati<-scan(file="dati.txt")
hist(dati,prob=T)
lines(density(dati),col="red")

### krosvalidācija
library(histogram)
hh<-histogram(dati,type="regular",penalty="cv")
hh$breaks
lines(density(dati,bw="ucv"),col="red")


### Regresija
### Nadaraya-Watson kodolu regresija ar iebūvētām funkcijām
dati<-read.table(file="lidar.txt",header=T)
x.dati<-dati$range
y.dati<-dati$logratio

# regressogramma
library(ggplot2)
library(HoRM)
regressogram(x.dati,y.dati,nbins=10) # drusku nekorekti

# drusku korektāk
regressogram2 = function(x,y,left,right,k,plotit,xlab="",ylab="",sub=""){
  ### assumes the data are on the interval [left,right]
  n = length(x)
  B = seq(left,right,length=k+1)
  WhichBin = findInterval(x,B)
  N = tabulate(WhichBin)
  m.hat = rep(0,k)
  for(j in 1:k){
    if(N[j]>0)m.hat[j] = mean(y[WhichBin == j])
  }
  if(plotit==TRUE){
    a = min(c(y,m.hat))
    b = max(c(y,m.hat))
    plot(B,c(m.hat,m.hat[k]),lwd=3,type="s",
         xlab=xlab,ylab=ylab,ylim=c(a,b),col="blue",sub=sub)
    points(x,y,cex=0.4)
  }
  return(list(bins=B,m.hat=m.hat))
}

par(mfrow=c(1,1))
plot(x.dati,y.dati,cex=0.7,xlim=c(min(x.dati)-10,max(x.dati)+10))

par(mfrow=c(1,1))
regressogram2(x.dati,y.dati,left=min(x.dati),
              right=max(x.dati),k=5,plotit=T,xlab="")
regressogram2(x.dati,y.dati,left=min(x.dati),
              right=max(x.dati),k=20,plotit=T,xlab="")


# Kodolu NW regresija ar diviem polinomiem (ar prognozēm +/-20 soļi)
library(KernSmooth)
plot(x.dati,y.dati,cex=0.7,xlim=c(min(x.dati)-20,max(x.dati)+20))
h<-dpill(x.dati,y.dati) # plug-in metode h noteikšanai (vajadzētu labāk CV, būs vēlāk)

fit<-locpoly(x.dati,y.dati,bandwidth = h, degree=0,
             range.x=c(min(x.dati)-20,max(x.dati)+20))
# ja degree=0, tad tā ir Nadaraya-Watsona kodolu regresija
lines(fit,col="red",lwd=2)
fit3<-lm(y.dati~poly(x.dati,degree=8,raw=T))
d<-seq(350,750,by=0.1)
lines(d, predict(fit3, data.frame(x.dati = d)),col="blue",lwd=2)

fit3<-lm(y.dati~poly(x.dati,degree=6,raw=T))
d<-seq(350,750,by=0.1)
lines(d, predict(fit3, data.frame(x.dati = d)),col="brown",lwd=2)
summary(fit3)

#####################################
### Degree=1 uzlabo robežu novirzi
plot(x.dati,y.dati,cex=0.7,xlim=c(min(x.dati)-20,max(x.dati)+20),xlab="",ylab="")
fit<-locpoly(x.dati,y.dati,bandwidth = h, degree=0,
             range.x=c(min(x.dati)-20,max(x.dati)+20))
# ja degree=0, tad tā ir Nadaraya-Watsona kodolu regresija
lines(fit,col="red",lwd=2)

# ja degree=1, tad to sauca par lokālo lineāro regresiju ar p=1
# un var parādīt, ka degree=1 regresija uzlabo robežu novirzi!
fit2<-locpoly(x.dati,y.dati,bandwidth = h, degree=1,
              range.x=c(min(x.dati)-20,max(x.dati)+20))
lines(fit2,col="blue",lwd=2)

# Vajadzētu uz kādiem citiem datiem paskatīties, to varēs labāk redzēt

#######################################
### Krosvalidācija NW kodolu regresijai
# Izveidotā N-W regresija programmā R (pašu veidotā)
nw.fun<-function(x,h,x.dati,y.dati)
{
  sum(K((x-x.dati)/h)*y.dati)/sum(K((x-x.dati)/h))
}
nw.fun<-Vectorize(nw.fun,vectorize.args="x")

X<-x.dati
Y<-y.dati
n<-length(x.dati)
K<-function(x) dnorm(x) # N(0,1) kodols

h_seq = seq(from=1,to=50, by=0.5)
CV_err_h2 = rep(NA,length(h_seq))
for(j in 1:length(h_seq)){
  h_using = h_seq[j]
  CV_err = rep(NA, n)
  for(i in 1:n){
    X_val = X[i]
    Y_val = Y[i]
    # validation set
    X_tr = X[-i]
    Y_tr = Y[-i]
    # training set
    #Y_val_predict = ksmooth(x=X_tr,y=Y_tr,kernel = "normal",bandwidth=h_using,
    #x.points = X_val)
    Y_val_predict = nw.fun(X_val,h_using,X_tr,Y_tr)
    CV_err[i] = (Y_val - Y_val_predict)^2
    # we measure the error in terms of difference square
  }
  CV_err_h2[j] = mean(CV_err)
}
CV_err_h2

plot(x=h_seq, y=CV_err_h2, type="b", lwd=3, col="red",xlab="",ylab="")
which(CV_err_h2 == min(CV_err_h2))
h_seq[which(CV_err_h2 == min(CV_err_h2))]
h.opt<-h_seq[which(CV_err_h2 == min(CV_err_h2))]

plot(x.dati,y.dati,cex=0.7,xlim=c(min(x.dati)-20,max(x.dati)+20),xlab="",ylab="")
fit<-locpoly(x.dati,y.dati,bandwidth = dpill(x.dati,y.dati), degree=0,
             range.x=c(min(x.dati)-20,max(x.dati)+20))
lines(fit,col="red",lwd=2)

fit<-locpoly(x.dati,y.dati,bandwidth = h.opt, degree=0,
             range.x=c(min(x.dati)-20,max(x.dati)+20))
lines(fit,col="blue",lwd=2)

### Citi gludinātāji
### https://stats.idre.ucla.edu/r/faq/how-can-i-explore-different-smooths-in-ggplot2/
plot(x.dati,y.dati)

cars.lo <- loess(y.dati ~ x.dati,span=0.35)
lines(x.dati,predict(cars.lo, data.frame(x.dati= x.dati), se = TRUE)$fit,col="blue")

### "Optimālā" gludināšanas parametra noteikša pēc CV 
n<-length(x.dati)

h_seq = seq(from=0.3,to=0.5, by=0.01)
CV_err_h2 = rep(NA,length(h_seq))
for(j in 1:length(h_seq)){
  h_using = h_seq[j]
  CV_err = rep(NA, n)
  for(i in 1:n){
    X_val = X[i]
    Y_val = Y[i]
    # validation set
    X_tr = X[-i]
    Y_tr = Y[-i]
    # training set
    #Y_val_predict = ksmooth(x=X_tr,y=Y_tr,kernel = "normal",bandwidth=h_using,
    #x.points = X_val)
    cars.lo <- loess(Y_tr ~ X_tr,span=h_using)
    Y_val_predict = predict(cars.lo, data.frame(x.dati=X_val))
    CV_err[i] = (Y_val - Y_val_predict)^2
    # we measure the error in terms of difference square
  }
  CV_err_h2[j] = mean(CV_err)
}
CV_err_h2

plot(x=h_seq, y=CV_err_h2, type="b", lwd=3, col="red",xlab="",ylab="")
which(CV_err_h2 == min(CV_err_h2))
h_seq[which(CV_err_h2 == min(CV_err_h2))]


plot(x.dati,y.dati)
lines(lowess(x.dati,y.dati), col = 3,lwd=2)

##########################################
# S&P 500 dati un neparametriskā regresija
##########################################
dati<-read.table(file="sp500.txt",header=T)
n<-length(dati[,1]);n
y.dati<-dati$Close[n:1]
x.dati<-1:n
plot(1:n,y.dati,cex=0.7)

#### laikrindu elementi
par(mfrow=c(1,2))
acf(y.dati)
acf(diff(y.dati))

plot(diff(log(y.dati)),type="l")
acf(diff(log(y.dati)))
pacf(diff(log(y.dati)))
fit <- auto.arima(y.dati)
par(mfrow=c(1,1))
plot(forecast(fit,h=1)) # prognoze ātri izlīdzinās par konstanti

fit <- auto.arima(diff(log(y.dati)))
par(mfrow=c(1,1))
plot(forecast(fit,h=10))

### slīdošais vidējais
slid.vid<-function(i,y.dati,h)
{
  n<-length(y.dati)
  i1<-max(1,i-h)
  i2<-min(n,i+h)
  mean(y.dati[i1:i2])
}
slid.vid<-Vectorize(slid.vid, vectorize.args="i")
n<-length(y.dati)
lines(1:n,slid.vid(1:n,y.dati,10),lty=2,col="brown",lwd=2)
lines(1:n,slid.vid(1:n,y.dati,20),lty=2,col="red",lwd=2)
lines(1:n,slid.vid(1:n,y.dati,40),lty=2,col="blue",lwd=2)

### neparametriskā regresija
dpill(1:n,y.dati)
fit0<-locpoly(1:n,y.dati,bandwidth=dpill(1:n,y.dati),degree=0)
lines(fit0,lty=5,col=6,lwd=2)
fit<-locpoly(1:n,y.dati,bandwidth=dpill(1:n,y.dati),degree=1)
lines(fit,lty=5,col=5,lwd=2)

n<-length(x.dati)
X<-x.dati
Y<-y.dati

h_seq = seq(from=1,to=10, by=0.5)
CV_err_h2 = rep(NA,length(h_seq))
for(j in 1:length(h_seq)){
  h_using = h_seq[j]
  CV_err = rep(NA, n)
  for(i in 1:n){
    X_val = X[i]
    Y_val = Y[i]
    # validation set
    X_tr = X[-i]
    Y_tr = Y[-i]
    # training set
    #Y_val_predict = ksmooth(x=X_tr,y=Y_tr,kernel = "normal",bandwidth=h_using,
    #x.points = X_val)
    Y_val_predict = nw.fun(X_val,h_using,X_tr,Y_tr)
    CV_err[i] = (Y_val - Y_val_predict)^2
    # we measure the error in terms of difference square
  }
  CV_err_h2[j] = mean(CV_err)
}
CV_err_h2

plot(x=h_seq, y=CV_err_h2, type="b", lwd=3, col="red",xlab="",ylab="")
which(CV_err_h2 == min(CV_err_h2))
h_seq[which(CV_err_h2 == min(CV_err_h2))]




# citi gludinātāji
lines(lowess(y.dati),col="green",lwd=2)
lines(lowess(y.dati, f=.1),col="orange",lwd=2)








