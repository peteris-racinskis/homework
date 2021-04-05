### aprakstošas statistikas
library(car)
Salaries
str(Salaries)
names(Salaries)
View(Salaries)
summary(Salaries)
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
getmode(Salaries$salary)
median(Salaries$salary)
mean(Salaries$salary)
boxplot(Salaries$salary)
