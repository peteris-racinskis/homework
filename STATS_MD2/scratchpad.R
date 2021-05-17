
# Columns 
# ell <- multipole moment l
# Cl <- TT power spectrum (micro Kelvins or something else her)
x <- df[1:700,]$ell
y <- df[1:700,]$Cl
plot(x,y)
cor(x,y)
ggplot(data=df[1:700,],aes(x=ell,y=Cl))+geom_point()+
  geom_smooth(method="lm",se=FALSE)
# Stuff they did in lecture
# LMAO YOU CAN JUST DO THIS
cor(df)
pairs(~ell + Cl + se + measerr + cosmic, data = df)

library(GGally)
ggpairs(iris, aes(colour = Species, alpha = 0.4))
ggpairs(df[,1:5]) 
pairs(df)

fit <- lm(df[1:400,]$ell~df[1:400,]$Cl)
fit2 <- lm(df[1:400,]$ell~df[1:400,]$Cl+I(df[1:400,]$Cl^3)+I(df[1:400,]$Cl^5))
anova(fit,fit2)

# Simple linear regression
plot(df$ell,df$Cl)
fit <- lm(df$ell~df$Cl)
abline(fit)
summary(fit)