# md4
# data - ToothGrowth
df <- ToothGrowth
attach(df)
summary(df)
# 2-factor ANOVA
tx<-with(df, interaction(supp,dose))
summary(aov(rank(len) ~ supp*dose))
summary(aov(len ~ tx))
summary(aov(rank(len) ~ tx))
amod <- aov(len ~ tx)
library(agricolae)
HSD.test(amod, "tx", group=TRUE,console=TRUE)
# 2-factor ANOVA on len(dose, supp)

library(multcomp)
tuk <- glht(amod, linfct = mcp(tx = "Tukey"),exact=F)
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1),cex.axis=0.5)
plot(tuk.cld)
par(opar)