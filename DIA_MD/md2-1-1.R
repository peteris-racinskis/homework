dist.de <- read.table("wg22_dist.txt")
fit <- cmdscale(dist.de, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]
plot(x,y,xlim=c(-150,150),ylim=c(-120,120))
text(x,y,labels=dist.names$V1)
x <- -x
y <- -y
plot(y,x,xlim=c(-120,120),ylim=c(-150,150))
text(y,x,labels=dist.names$V1)

