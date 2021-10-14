df <- read.csv("gapC.csv")
attach(df)
# boxplot by continent
boxplot(breastcancer~continent)
# ANOVA with post-hoc tuckey
fit<-aov(breastcancer~continent)
summary(fit) # - not the same pop
# 
f<-TukeyHSD(fit)
op <- par(mar= c(4,5,3,3) + 0.1, cex.axis=0.5)
plot(f,las=1)
par(op)
f
# nonparametric anova
library(rstatix)
kruskal.test(breastcancer~continent)
dunn_test(df, breastcancer~continent)
# for comparison
pairwise.wilcox.test(breastcancer,continent,p.adjust.method="BH")
