# md3
# ANOVA
# 1. get data chickwts
df <- chickwts
attach(df)
# 2. do anova procedure
#   - boxplots and descriptive statistics
summary(df)
boxplot(weight~feed)
#   - ANOVA models and conclusions
fit<-aov(weight~feed)
summary(fit)
# groups are clearly distinct
#   - Post-hoc comparisons of pairs if required
#     Some groups look like they might overlap,
#      so use the tukey test to check
r<-TukeyHSD(fit)
# Fit to width
op <- par(mar= c(4,5,3,3) + 0.1, cex.axis=0.5)
plot(TukeyHSD(fit),las=1)
par(op)
#   - ANOVA condition check
#     1. normality (check if groups normally distributed)
# R pipe operator %>%
library(dplyr)
library(rstatix)
df %>% group_by(feed) %>% shapiro_test(weight)
# couldn't reject normality
#     2. homoscedacity (check if)
leveneTest(weight,feed)
bartlett.test(weight,feed)
# Couldn't reject homoscedacity
#   - nonparametric ANOVA kruskal.test,
#     ^ use if fail normality or homoscedacity <- not required
kruskal.test(weight~feed)
# rejected, as expected
#then by pairs if needed
pairwise.wilcox.test(weight,feed,p.adjust.method="BH")
#   ^ not strictly a post-hoc (t-test between categories)
#   - nonparametric post-hoc tests
dunn_test(df, weight~feed)
#   - conclusions