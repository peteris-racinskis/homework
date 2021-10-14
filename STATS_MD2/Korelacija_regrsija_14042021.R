### dati cars, mtcars
library(ggplot2)
ggplot(data=cars,aes(x=speed,y=dist))+geom_point()+
  geom_smooth(method = "lm", se = FALSE)

cor(cars$speed,cars$dist,method=c("pearson"))
cor(cars$speed,cars$dist,method=c("spearman"))
cor(cars$speed,cars$dist,method=c("kendall"))

cor.test(cars$speed,cars$dist)
## Secinājums: korelācija ir statistiski nozīmīga (pie nozīmības
## līmeņa 5%), jo p-vērtība < 0.05.

x<-seq(-3,3,by=0.01)
y<-x^2 + rnorm(length(x),0,1)
plot(x,y)
cor(x,y)

# Korelācijas mtcars datiem
View(mtcars)
cor(mtcars)

pairs(mtcars)

library(GGally)
ggpairs(iris, aes(colour = Species, alpha = 0.4))
ggpairs(mtcars[,1:5]) 
pairs(mtcars)

library(corrplot)
m<-cor(mtcars)
corrplot(m)
p.mat <- cor_pmat(mtcars)

install.packages("ggcorrplot")
library(ggcorrplot)
ggcorrplot(p.mat)
# Sīkāka informācija
# http://www.sthda.com/english/wiki/ggcorrplot-visualization-of-a-correlation-matrix-using-ggplot2

### Lineārā regresija
ggplot(data=cars,aes(x=speed,y=dist))+geom_point()+
  geom_smooth(method = "lm", se = FALSE)

# Vienkāršā lineārā regresija
y.dati<-cars$dist
x.dati<-cars$speed
plot(x.dati,y.dati)

fit<-lm(y.dati~x.dati)
abline(fit)
summary(fit)
fit$coefficients
# 65% no datu variācijas tiek izskaidroti ar vienkāršās lineārās regresijas palīdzību!

# Diagnostika
# https://www.statmethods.net/stats/rdiagnostics.html
# 1) neatkarība
plot(x.dati,fit$residuals)
durbinWatsonTest(fit) # veic hipotēžu pārbaudi H0: korelācija pie laga 1 ir 0
# Secinājums: p-vērtība> 0.05, tātad nevar noraidīt, ka (auto)korelācija ir 0

# 2) normalitāte
qqnorm(fit$residuals)
qqline(fit$residuals)
shapiro.test(fit$residuals)
# Normalitāte tiek noraidīta pie alpha=0.05

# 3) dispersijas viendabīgums (homoscedasticity)
ncvTest(fit)
# tiek noraidīta hipotēze par konstantu dispersiju, jo p-vērtība<0.05

### ANOVA statistisko metodi izmanto, lai salīdzinātu regresiju modeļus savā starpā
fit<-lm(y.dati~x.dati)
fit2<-lm(y.dati~x.dati+I(x.dati^2))
summary(fit2)
anova(fit,fit2) # ANOVA neuzrāda statistiski nozīmīgu atšķirību starp modeļiem

#### LIDAR dati no Larry Wasserman mājaslapas
# http://www.stat.cmu.edu/~larry/all-of-nonpar/data.html

dati<-read.table(file="lidar.txt",header=T)
x.dati<-dati$range
y.dati<-dati$logratio
plot(x.dati,y.dati)

fit<-lm(y.dati~x.dati)
fit2<-lm(y.dati~x.dati+I(x.dati^2))
summary(fit)
abline(fit)
# Diagnostika
# 1) atlikumu neatkarība!
plot(x.dati,fit$residuals)
durbinWatsonTest(fit) # noraidām, ka (auto)korelācija ir 0
cor.test(x.dati,fit$residuals) 
# lai gan atlikumi ir nekorelēti, tomēr stipri atkarīgi!

summary(fit2)
anova(fit,fit2)



















