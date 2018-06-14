#
# setwd(dir = "~/Téléchargements/")
# build()
# install.packages("rasterFrag_0.0-1.tar.gz", repos = NULL, type = "source")

library(raster)
library(rasterFrag)

setwd(dir = "~/github/MAPS-11/COMPOTE/")

csv.l <- list.files(path = "nlogo/data/")
csv.l <- csv.l[csv.l != "farmers.csv"]

Ftheo <- prepareFragmentationTheo(nrepl=100,nrow=100,ncol=100)
Ftheo <- theo

my.df <- NULL
for(i in 1:length(csv.l)){
  a <- raster(as.matrix(read.csv(paste0("nlogo/data/",csv.l[i]))))
  a1<- (a==0)*1
  a2<- (a==0.5)*1
  a3<- (a==1)*1
  print(paste0("nlogo/data/",csv.l[i]))
  if_v1 <- indexFrag(a1,threshold = 0.5,theo = Ftheo)[[1]]
  if_v2 <- indexFrag(a2,threshold = 0.5,theo = Ftheo)[[1]]
  if_v3 <- indexFrag(a3,threshold = 0.5,theo = Ftheo)[[1]]
  v <- c(csv.l[i], if_v1, if_v2, if_v3)
  my.df <- rbind(my.df, v)
}

my.df <- as.data.frame(my.df)
names(my.df)<-c("file","if1","if2","if3")

write.csv(my.df, file = "results/fragmentation_space.csv", row.names = T)


