dist.de <- read.table("Results-1980-2015-dist.txt")
names <- read.table("Results-1980-2015-name.txt")
fit <- cmdscale(dist.de, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]
plot(x,y, pch=4, col="grey", xlim=c(-1.5,2.5))
text(x,y,labels=names$V1)
x <- -x
y <- -y
plot(y,x,xlim=c(-120,120),ylim=c(-150,150))
text(y,x,labels=dist.names$V1)

