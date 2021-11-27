library(foreign)
library(vegan)
library(rgl)
data <- read.arff('unbalanced.arff')
# color map 
colors <- function(status) {
  sapply(status, function(i) {
    if (i == "Active"){
      "red"
    } else {
      "blue"
    }
  })
}
# corrected source code for Isomap()
Isomap  = function(Distances,k,OutputDimension=2,PlotIt=FALSE,Cls){
  res=vegan::isomap(Distances,ndim = OutputDimension,k=k,fragmentedOK=T, path = "shortest")
  ProjectedPoints=res$points
  return(list(ProjectedPoints=ProjectedPoints))
}

# Step 1: calculate distance matrix between data vectors R^p->R^n
color_row <- colors(data$Outcome)
trimmed <- data[,1:length(data[1,])-1] # remove the class row
distances <- as.matrix(dist(as.matrix(trimmed))) # get distance matrix
# Step 2: run isomap on the distance matrix with parameter K
fit <- Isomap(distances, 5, 3)
x <- fit$ProjectedPoints[,1]
y <- fit$ProjectedPoints[,2]
z <- fit$ProjectedPoints[,3]
plot(x,y,col=color_row)
plot3d(x,y,z,
       col=color_row,
       type="s",
       radius=3.5)





# error in source code
Isomap  = function(Distances,k,OutputDimension=2,PlotIt=FALSE,Cls){
  # author: MT 06/2015
  if(missing(Distances))
    stop('No Distances given')
  Distances;
  if(!is.matrix(Distances))
    stop('Distances has to be a matrix, maybe use as.matrix()')
  
  if (!requireNamespace('vegan')) {
    message(
      'Subordinate projection package is missing. No computations are performed.
            Please install the package which is defined in "Suggests".'
    )
    return(
      list(
        Cls = rep(1, nrow(Distances)),
        Object = "Subordinate projection package is missing.
                Please install the package which is defined in 'Suggests'."
      )
    )
  }
  
  if(missing(k)) stop('k nearest neighbor value missing')
  
  res=vegan::isomap(Distances,ndim = OutputDimension,k=k,fragmentedOK=T, path = "shortest")
  # requireRpackage("RDRToolbox",biocite=T)
  # 
  # 
  # ProjectedPoints=matrix(unlist(Isomap(data=Data,dim=OutputDimension,k=k,verbose=T)),ncol=OutputDimension)
  ProjectedPoints=res$points
  if(PlotIt){
    if(missing(Cls)){
      AnzData=nrow(Distances)
      Cls=rep(1,AnzData)
    }  
    
    string=paste0('Isomap projection with k ',k)
    #ClassPlot(ProjectedPoints[,1],ProjectedPoints[,2],Cls=Cls,Title=string)
    PlotProjectedPoints(ProjectedPoints,Cls,main=string)
  }                    
  return(list(ProjectedPoints=ProjectedPoints))
  
}