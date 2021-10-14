#### Datu piemērs no prezentācijas
dati<-c(2.20,2.20,2.40,2.40,2.50,2.70,2.80,2.90,
3.03, 3.03, 3.10, 3.37, 3.40, 3.40, 3.40, 3.50,
3.60, 3.70, 3.70, 3.70, 3.70, 3.77, 5.28, 28.95)

n<-length(dati)
boxplot(dati[-n])
hist(dati[-n])
shapiro.test(dati[-n])

# butstrapa metode ticamības intervālam asimetrijas koeficientam
N<-1000
rez<-replicate(N,skewness(sample(dati[-n],replace=T)))
alpha<-0.05
quantile(rez,alpha/2)
quantile(rez,1-alpha/2)
# 0 pieder ticamības intervālu, simetriju noraidīt nevaram!

library(psych)
summary(dati)
describe(dati)

sd(dati)
mad(dati)

### Hūbera novērtējums, šķeltā vidējā vērtība
median(dati)

library(MASS)
huber(dati)
mean(dati,trim=0.1)

### Ticamības intervāli datu piemēram
### https://www.researchgate.net/profile/David_Booth14/post/Regression_with_dummy_variable_Assumption_for_t-test/attachment/5cc095573843b01b9b9c5167/AS%3A751256914100228%401556125014975/download/RobustT.pdf
t.test(dati)$conf.int

### robusti ticamības intervāli vidējai vērtīai
mean(dati)-qt(1-alpha/2,n-1)*sd(dati)/sqrt(n)
mean(dati)+qt(1-alpha/2,n-1)*sd(dati)/sqrt(n)

median(dati)-qt(1-alpha/2,n-1)*mad(dati)/sqrt(n) # robustie tic.int
median(dati)+qt(1-alpha/2,n-1)*mad(dati)/sqrt(n) # robustie tic.int

### Bez izlecēja
t.test(dati[-n])$conf.int

### Yuen tests šķeltām vidējām vērtībām
### Sīkāka info Wilcox gramatā https://www.amazon.com/Introduction-Estimation-Hypothesis-Statistical-Modeling/dp/0123869838
library(DescTools)
YuenTTest(dati)$conf.int

### Bustrapa ticamības intervāli šķeltai vidējai vērtībai ar 0.20 šķelšanu
N<-1000
rez<-replicate(N,mean(sample(dati,replace=T),trim=0.2))
alpha<-0.05
quantile(rez,alpha/2)
quantile(rez,1-alpha/2)


### Piesārņotie modeļi
contaminated.sample <- function(mu,sigma,n,p,mu2,sigma2)
{
x<-1:n
for(i in 1:n) 
  {
  if(rbinom(1,1,p)==1)
   x[i] <- rnorm(1,mu2,sigma2) else
   x[i] <- rnorm(1,mu,sigma)
  }
return(x)
}
x <- contaminated.sample(0,1,50,.10,0,10)
y <- contaminated.sample(1,3,50,.10,1,15)
boxplot(x,y)
describe(y)

### Robusta regresija
library(robustbase)
attach(starsCYG)
fit<-lm(log.light ~ log.Te)
summary(fit)

plot(log.Te,log.light,col="blue")
abline(fit,col="red",lwd=2,lty=2)
cbind(coef(fit),confint(fit, level = 0.95))

res <- lmrob(log.light ~ log.Te,
             data=starsCYG)
summary(res)
cbind(coef(res),confint(res, level = 0.95))
abline(res,col="green",lwd=2,lty=2)

#### izmetam novērojumus
c(11,20,30,34)
fit<-lm(log.light[-c(11,20,30,34)] ~ log.Te[-c(11,20,30,34)])
summary(fit)
abline(fit,lwd=2,lty=2,col="brown")
#plot(log.Te[-c(11,20,30,34)], log.light[-c(11,20,30,34)])






































