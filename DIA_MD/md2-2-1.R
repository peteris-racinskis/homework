library(foreign)
library(tsne)
library(rgl)

trim <- function(df){
  df[,1:length(df[1,])-1]
}

colors <- function(df) {
  sapply(df, function(x) {
    if (x == "b") {
      "blue"
    } else {
      "red"
    }
  })
}

plot.tsne <- function(df, perp=30, iter=400, class=NULL, plt=T, k=2, ret=F) {
  transformed <- tsne(df, k = k, perplexity = perp, initial_dims = length(df[1,]), max_iter = iter)
  x <- transformed[,1]
  y <- transformed[,2]
  if (plt) {
    plot(x,y,col=class,xlab="comp1",
         ylab="comp2",main=sprintf("t-SNE perplexity = %d iter = %d", perp, iter))
  }
  if (ret) {
    transformed
  }
}

plot.pca <- function(df, class){
  pca <- prcomp(df)
  plot(pca$x[,1:2],col=col_row,main="PCA (2 largest)")
}

data <- read.arff("ionosphere.arff")
trimmed <- trim(data)
col_row <- colors(data[,length(data[1,])])
plot.pca(trimmed, col_row)
plot.tsne(trimmed,3,class=col_row,)
plot.tsne(trimmed,10,class=col_row)
plot.tsne(trimmed,20,class=col_row)
plot.tsne(trimmed,30,class=col_row)
plot.tsne(trimmed,50,class=col_row)
plot.tsne(trimmed,100,class=col_row)

df <- plot.tsne(trimmed,50,iter=1000,class=col_row,ret=T,plt=F,k=3)
plot3d(df,col=col_row,type="s",radius="0.5")
