library(tsne)
library(foreign)

trim <- function(df){
  df[,1:length(df[1,])-1]
}

colors <- function(df) {
  sapply(df, function(x) {
    if (x == "b") { "blue" } 
    else { "red" }})
}

plot.tsne <- function(df, distance="", perp=30, iter=400, class=NULL, plt=T, k=2, ret=F) {
  transformed <- tsne(df, k = k, perplexity = perp,
                      initial_dims = length(df[1,]), max_iter = iter)
  x <- transformed[,1]
  y <- transformed[,2]
  if (plt) {
    plot(x,y,col=class,xlab="comp1",
         ylab="comp2",
         main=sprintf("Distance metric: %s", distance))
  }
  if (ret) {
    transformed
  }
}


plot.umap <- function(df, config, class=NULL, distance="", knn=15, plt=T, ret=T) {
  transformed <- umap(df, config)
  x <- transformed$layout[,1]
  y <- transformed$layout[,2]
  if (plt) {
    plot(x,y,col=class,xlab="comp1",
         ylab="comp2",
         main=sprintf("Distance metric %s, knn = %d", distance, knn))
  }
  if (ret) {
    transformed
  }
}




data <- read.arff("ionosphere.arff")
trimmed <- trim(data)
col_row <- colors(data[,length(data[1,])])

dist_euc <- dist(trimmed, method="euclidean")
dist_man <- dist(trimmed, method="manhattan")
dist_che <- dist(trimmed, method="maximum")

#plot.tsne(dist_euc,30,class=col_row, distance="euclidean")
#plot.tsne(dist_man,30,class=col_row, distance="manhattan")
#plot.tsne(dist_che,30,class=col_row, distance="chebishev")

library(umap)
euclidean.config_15 <- umap.defaults
euclidean.config_30 <- umap.defaults
manhattan.config_15 <- umap.defaults
manhattan.config_30 <- umap.defaults
cosine.config_15 <- umap.defaults
cosine.config_30 <- umap.defaults
euclidean.config_15$metric <- "euclidean"
euclidean.config_30$metric <- "euclidean"
euclidean.config_30$n_neighbors <- 30
manhattan.config_15$metric <- "manhattan"
manhattan.config_30$metric <- "manhattan"
manhattan.config_30$n_neighbors <- 30
cosine.config_15$metric <- "cosine"
cosine.config_30$metric <- "cosine"
cosine.config_30$n_neighbors <- 30

plot.umap(trimmed, euclidean.config_15, class=col_row, distance="euclidean")
plot.umap(trimmed, manhattan.config_15, class=col_row, distance="manhattan")
plot.umap(trimmed, cosine.config_15, class=col_row, distance="cosine")
plot.umap(trimmed, euclidean.config_30, class=col_row, distance="euclidean", knn=30)
plot.umap(trimmed, manhattan.config_30, class=col_row, distance="manhattan", knn=30)
plot.umap(trimmed, cosine.config_30, class=col_row, distance="cosine", knn=30)