# md5
# 1. read in data from server
df <- as.numeric(read.delim("dati2_5.txt",header=F,sep=" "))
# 2. write code for a cross validation function to estimate 
#    pdf from data
# 3. use cross validation to find bandwidth for the data
# unbiased cross-validation function
cross_validated<-bw.ucv(df)
# 4. construct pdf with bandwidth, add to histogram
library(histogram)
hh<-histogram(df,type="regular",penalty="cv")
lines(density(df,bw=1),col="blue",lwd=2)
lines(density(df,bw=0.01),col="green",lwd=2)
lines(density(df,bw="ucv"),col="red",lwd=3)
# 5. compare to other methods
silverman_heuristic<-function(x){
  sd(x)*(length(x)**(-1/5))*1.06
}
silver <- silverman_heuristic(df)
improved_silverman <- bw.nrd(df)
improved_silverman2 <- bw.nrd0(df)
silver
improved_silverman
improved_silverman2
lines(density(df,bw=silver),col="black",lwd=2)