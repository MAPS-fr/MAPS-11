## Generate sp. for COMPOTE model
## 12 juin 2012
library(NLMR)
library(raster)

#set.seed(123)
setwd("~/github/MAPS-11/COMPOTE/")

## generate polygon
for(h in c(10,100,1000)){
  for (i in 1:30){
    # simulate polygonal landscapes
    mosaicgibbs <- nlm_mosaicgibbs(ncol = 100,
                                   nrow = 100,
                                   germs = h,
                                   R = 2,
                                   patch_classes = 3)
    # visualize the NLM
    #rasterVis::levelplot(mosaicgibbs, margin = FALSE, par.settings = rasterVis::viridisTheme())
    write.csv(matrix(values(mosaicgibbs), nrow = 100, ncol = 100),
              file = paste0("nlogo/data/polygon_gem",h,"_rep_",i,".csv"), row.names = F)
  }
}


## generate random
for(i in 1:10){
  write.csv(matrix(sample(seq(from = 0, to = 1, by = 0.5), size = 10000, replace = TRUE),
            nrow = 100, ncol = 100),
            file = paste0("nlogo/data/random_",i,".csv"), row.names = F)
}

# generate farmers' IDs   #C'est pourri, mais ?a marche:
m1=matrix(rep(rep(1:10,each=10),10),nrow=10,byrow=T)
m1=rbind(m1,m1+10,m1+20,m1+30,m1+40,m1+50,m1+60,m1+70,m1+80,m1+90) #ne marche pas avec rep ou seq... ???
image(m1)
write.csv(m1-1,file = paste0("nlogo/data/farmers.csv"), row.names = F)

