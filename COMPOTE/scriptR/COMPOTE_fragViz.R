## Un script pour faire un peut le point sur la caractérisation des formes spatiales.

library(stringr)
library(ggplot2)
library(reshape2)

setwd("~/github/MAPS-11/COMPOTE/nlogo/result/")
frag.df <- read.csv(file = "fragmentation_space.csv")

## We want to understand the behavior of spation configuration regarding the fragmentation index.
### First we are looking for polygons
frag.poly <- frag.df[!is.na(str_match(as.character(frag.df$file),"gem")),]
for(i in 1:length(frag.poly$file)){
  frag.poly$type[i] <- unlist(str_split(as.character(frag.poly$file[i]),"_"))[1]
  frag.poly$gem[i] <- unlist(str_split(as.character(frag.poly$file[i]),"_"))[2]
}
frag.poly <- frag.poly[,-c(1,2)]

### we are looking for random configuration

frag.rand <- frag.df[is.na(str_match(as.character(frag.df$file),"gem")),]
for(i in 1:length(frag.rand$file)){
  frag.rand$type[i] <- unlist(str_split(as.character(frag.rand$file[i]),"_"))[1]
  frag.rand$gem[i] <- unlist(str_split(as.character(frag.rand$file[i]),"_"))[1]
}
frag.rand <- frag.rand[,-c(1,2)]


frag <- rbind(frag.poly,frag.rand)

### Visualisation

gg.df <- melt(frag, id=c("type","gem"))

ggplot(data = gg.df)+
  geom_boxplot(aes(x = gem, y = value))+
  facet_grid(~variable)+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

