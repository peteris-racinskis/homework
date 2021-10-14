# Vienfaktora ANOVA (one-way ANOVA)
data(InsectSprays)
attach(InsectSprays)
boxplot(count~spray)

fit<-aov(count~spray)
summary(fit)
## Tukey Post-hoc tests vairākkārtīgai grupu salīdzināšanai pa divām grupām
TukeyHSD(fit)
plot(TukeyHSD(fit),las=1)

### ANOVA nosacījumi

# Normalitāte
shapiro.test(count[spray=="A"])
shapiro.test(count[spray=="B"])
shapiro.test(count[spray=="C"])
shapiro.test(count[spray=="D"])

# homogenitātes tests
bartlett.test(count ~ spray, data = InsectSprays)
leveneTest(count ~ spray, data = InsectSprays)

# Tipiski, ka ANOVA nosacījumi neizpildās (arī šajā gadījumā)

# 1.metode: var mēģināt datus aizvietot ar rangiem un pielietot to
# pašu ANOVU (tas strādā tikai vienkāršiem dizainiem)
fit<-aov(rank(count)~spray)
summary(fit)
## Tukey Post-hoc tests vairākkārtīgai grupu salīdzināšanai pa divām grupām
TukeyHSD(fit)
plot(TukeyHSD(fit),las=1)

### 2.metode: pielietot rangu testus, piemēram, Kruskal-Wallis testu
# http://www.sthda.com/english/wiki/kruskal-wallis-test-in-r
kruskal.test(count~spray)

### Vairākkārtīgiem salīdinājumiem ir divas iespējas
### 1) var lietot pāru Wilkoksona testu

pairwise.wilcox.test(count, spray,
p.adjust.method = "BH")

### 2) var lietot post hoc Dunn.testu.
library(dunn.test)
dunn.test(count,spray)

# Secinājums: neparametriskie rangu testi dod samērā līdzīgus secinājumus, kuri
# atšķiras nedaudz savā starpā un stipri atšķiras no (parametriskās)
# ANOVA procedūras

# Divfaktoru ANOVA
# links https://stats.stackexchange.com/questions/31547/how-to-obtain-the-results-of-a-tukey-hsd-post-hoc-test-in-a-table-showing-groupe

library(foreign)
yield <- read.dta("http://www.stata-press.com/data/r12/yield.dta")
tx <- with(yield, interaction(fertilizer, irrigation))
summary(aov(yield ~ fertilizer*irrigation, data=yield))
#amod <- aov(rank(yield) ~ tx, data=yield)
mod <- aov(rank(yield) ~ tx, data=yield)
library(agricolae)
HSD.test(amod, "tx", group=TRUE,console=TRUE)

library(multcomp)
tuk <- glht(amod, linfct = mcp(tx = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

####### Afex pakotne dod iespēju aplūkot dažādus ANOVA dizainus 
# (ar un bez atkārtojumiem laikā, arī veicot ANCOVA, kas veido
# korekciju attiecībā pret citiem mainīgajiem lielumiem)

# Lietošanas piemērs https://ademos.people.uic.edu/Chapter21.html
# Sīkāk  dažādos dizainus un situācijas lekcijā neaplūkosim











