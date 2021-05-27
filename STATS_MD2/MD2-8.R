# md 8 robust stats
# 1. import data
library(robustbase)
df<-coleman
attach(df)
# 2. descriptive stats for value Y and all the arguments (salary, ...)
#     Describe the variable TYPES, draw boxplots and histograms
library(psych)
describe(df$Y)
boxplot(df$Y)
hist(df$Y)
describe(df$salaryP)
boxplot(df$salaryP)
hist(df$salaryP)
describe(df$fatherWc)
boxplot(df$fatherWc)
hist(df$fatherWc)
describe(df$sstatus)
boxplot(df$sstatus)
hist(df$sstatus)
describe(df$teacherSc)
boxplot(df$teacherSc)
hist(df$teacherSc)
describe(df$motherLev)
boxplot(df$motherLev)
hist(df$motherLev)
# 3. look at the correlations between vars
correlations<-cor(df)
correlations[6,]
correlations[3,]
# 4. Do multifactor linear regression for Y, do all the tests and checks
#     (linreg conditions/requirements check, diagnostics, etc)
fit_multi<-lm(Y~., data=df)
summary(fit_multi)
library(car)
vif(fit_multi)
fit_multi<-step(fit_multi)
summary(fit_multi)
plot(fit_multi)
# Residuals vs fitted: Minor visually apparent correlation
# Normal QQ: Two significant oultiers, mostly normally distributed residuals
# Scale-Location: not much apparent heteroscedacity
# Leverage: No outliers with leverage
acf(fit_multi$residuals) 
durbinWatsonTest(fit_multi)
library(nortest)
lillie.test(fit_multi$residuals)
ncvTest(fit_multi)
# 5. Do robust regression, compare p-values, r-squared, parameter evals
fit<-lmrob(Y~.,data=df)
summary(fit)

plot(fit)
# Residuals vs leverage: One outlier with leverage (point 18)
# Normal QQ vs residuals: All error terms besides outliers normally distributed
# Response vs fitted: Two significant outliers, otherwise close fit
# Residuals vs fitted: No clear pattern, can assume residuals are IID
# Sqrt of residuals: can see some heteroscedacity (increasing with Y)

