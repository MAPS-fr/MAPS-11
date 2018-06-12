## Generate sp. for COMPOTE model
## 12 juin 2012
library(NLMR)

#set.seed(123)
setwd("~/github/MAPS-11/COMPOTE/")

## generate polygon
for (i in 1:100){
  # simulate polygonal landscapes
  mosaicgibbs <- nlm_mosaicgibbs(ncol = 100,
                                 nrow = 100,
                                 germs = 20,
                                 R = 2,
                                 patch_classes = 3)
  # visualize the NLM
  #rasterVis::levelplot(mosaicgibbs, margin = FALSE, par.settings = rasterVis::viridisTheme())
  write.csv(matrix(values(mosaicgibbs), nrow = 100, ncol = 100),
            file = paste0("nlogo/data/polygon_",i,".csv"), row.names = F)
}

## generate random
for(i in 1:10){
  write.csv(matrix(sample(seq(from = 0, to = 1, by = 0.5), size = 10000, replace = TRUE),
            nrow = 100, ncol = 100),
            file = paste0("nlogo/data/random",i,".csv"), row.names = F)
}

