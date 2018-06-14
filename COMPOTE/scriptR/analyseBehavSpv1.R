 # Analyse des résultats en section para...
 mt<-read.csv("../results/COMPOTE experiment-dynDesease-table.csv",skip=6)
 
 colnames(mt)<-c("run","nb_managers","Svar1","radiusInfestMax","alpha","betap","Svar2","rProd","file_number","file_name","tpsExtermination","Svar3","Iinit","week","pct_infected_tot","pct_var1","pct_var2" )
 mt$SpatialModality<-as.numeric(mt$file_name)
 #mt$SpatialModality[mt$SpatialModality == 4]<-0
 mt$pct_var1<- mt$pct_var1 / mt$pct_infected_tot
 mt$pct_var2<- mt$pct_var2 / mt$pct_infected_tot
 mt$pct_var3<- 1 - (mt$pct_var1 + mt$pct_var2)
 
 x=c(1,2,4,8,16,32)
 add.alpha <- function(COLORS, ALPHAS){
          if(missing(ALPHAS)) stop("provide vector 'ALPHAS' values between 0 and 1, one for each COLOR")
          RGB <- col2rgb(COLORS, alpha=TRUE)
          RGB[4,] <- round(RGB[4,]*ALPHAS)
          NEW.COLORS <- rgb(RGB[1,], RGB[2,], RGB[3,], RGB[4,], maxColorValue = 255)
          return(NEW.COLORS)
  }
  col.trans <- add.alpha(c("black",  "red", "green","blue","cyan","purple"), 0.1)

 #analyse   pct_infected_tot
 boxplot(pct_infected_tot~radiusInfestMax+tpsExtermination+SpatialModality,data=mt)
 
Twoplots<-function(var_an,label=""){
 meanPtot<-with(mt,by(var_an,list(radiusInfestMax,tpsExtermination,SpatialModality),mean))
 meanPtot<-array(as.vector(meanPtot),dim=c(6,6,4))
 minPtot<-with(mt,by(var_an,list(radiusInfestMax,tpsExtermination,SpatialModality),min))
 minPtot<-array(as.vector(minPtot),dim=c(6,6,4))
 maxPtot<-with(mt,by(var_an,list(radiusInfestMax,tpsExtermination,SpatialModality),max))
 maxPtot<-array(as.vector(maxPtot),dim=c(6,6,4))
  
 #graph:  
 plot(1:32,type="n",xlab="Radius",ylab=label,bty="l",ylim=c(0,1))
 for(i in 1:6){
   for(j in  1:4){
     lines(x,meanPtot[,i,j],col=i,lty=j)
   }
 }
 legend("bottomright",legend=c(as.character(seq(30,180,by=30)),"random","g10","g100","g1000"),col=c(1:6,rep(1,4)),lty=c(rep(1,6),1:4),bty="n")
 #analyse for speed 120 (slow growth)
# windows()
 plot(1:32,type="n",xlab="Radius",ylab=label,bty="l",ylim=c(0,1), main="for slow growth desease (t=120)")
 for(i in 4:4){
   for(j in  1:4){
     lines(x,meanPtot[,i,j],col=j)
   }
 }
  for(j in 1:4){
      polygon(x=c(x, rev(x)), y=c(minPtot[,i,j], rev(maxPtot[,i,j])), col=col.trans[j], border=NA)
  }
  for(j in 1:4){
      lines(x,meanPtot[,i,j],col=j)
  }
 legend("bottomright",legend=c("random","g10","g100","g1000"),col=c(1:4),lty=1,bty="n")
}
pdf("analyseBehavSpv1.pdf",width=8,height=6)
Twoplots(mt$pct_infected_tot,label="Infestation") 
Twoplots(mt$pct_var1,label="Percent Infested Var1") 
Twoplots(mt$pct_var2,label="Percent Infested Var2") 
Twoplots(mt$pct_var3,label="Percent Infested Var3") 
dev.off()
