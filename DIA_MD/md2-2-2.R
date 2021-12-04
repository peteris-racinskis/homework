library(reticulate)
library(foreign)
use_virtualenv("~/repos/homework/DIA_MD/.venv")
pacmap <- import("pacmap")
data <- read.arff("ionosphere.arff")

trim <- function(df){
  df[,1:length(df[1,])-1]
}

colors <- function(df) {
  sapply(df, function(x) {
    if (x == "b") {
      "blue"
    } else {
      "red"
    }})
}

pac_wrapper <- function(mat, col,
                        init="pca", k=10, MN_ratio=0.5,
                        FP_ratio=2, var="default") {
  embedding <- pacmap$PaCMAP(
    MN_ratio = MN_ratio,
    FP_ratio = FP_ratio,
    n_neighbors = as.integer(k))
  fit<-embedding$fit_transform(mat, init=init)
  plot(fit,
       col=col,
       xlab="comp 1",
       ylab="comp 2",
       main=sprintf("PaCMAP variable = %s init = %s k = %d MN = %.2f FP = %.2f",
                    var, init, k, MN_ratio, FP_ratio))
}

col_row <- colors(data[,length(data[1,])])
mat <- as.matrix(trim(data))
# hyperparams - random  or PCA init
pac_wrapper(mat, col_row, init="pca", var="init") #pca is default
pac_wrapper(mat, col_row, init="random", var="init")
# hyperparams - NB, basic nearest neigbours count from which MN, FP computed
# works to first find NB + 50 Euclidean closes points for each i with some KNN 
# algo, then find the NB closest points in terms of the normalized distance
pac_wrapper(mat, col_row, k=5, var="k")
pac_wrapper(mat, col_row, k=10, var="k")
pac_wrapper(mat, col_row, k=20, var="k")
pac_wrapper(mat, col_row, k=50, var="k")
# hyperparams - MN ratio, used to select mid near points for early iter global
pac_wrapper(mat, col_row, MN_ratio=0, var="MN")
pac_wrapper(mat, col_row, MN_ratio=0.25, var="MN")
pac_wrapper(mat, col_row, MN_ratio=0.5, var="MN") # default
pac_wrapper(mat, col_row, MN_ratio=1, var="MN")
pac_wrapper(mat, col_row, MN_ratio=2, var="MN")
# hyperparams - FP ratio, select far points for strong repulsion if close
pac_wrapper(mat, col_row, FP_ratio=0.1, var="FP") # can't be less than 1
pac_wrapper(mat, col_row, FP_ratio=0.5, var="FP")
pac_wrapper(mat, col_row, FP_ratio=1, var="FP")
pac_wrapper(mat, col_row, FP_ratio=2, var="FP") #default
pac_wrapper(mat, col_row, FP_ratio=4, var="FP")

