 # Donnees sans gestion:
 md<-read.csv("../results/COMPOTE experiment-dynDesease-table.csv",skip=6)
 colnames(md)<-c("run","nb_managers","Svar1","radiusInfestMax","alpha","betap","Svar2","rProd","file_number","file_name","tpsExtermination","Svar3","Iinit","week","pct_infected_tot","pct_var1","pct_var2" )
 md$SpatialModality<-as.numeric(md$file_name)
 #mt$SpatialModality[mt$SpatialModality == 4]<-0
 md$pct_var1<- md$pct_var1 / md$pct_infected_tot
 md$pct_var2<- md$pct_var2 / md$pct_infected_tot
 md$pct_var3<- 1 - (md$pct_var1 + md$pct_var2)
 
 valbase30_8<-0#TODO pour papier
 
 
 # Analyse des résultats protocole 2
 mt1<-read.csv("../results/COMPOTE EffetControleurs30_8-table.csv",skip=6)
 mt2<-read.csv("../results/COMPOTE EffetControleurs180_4_Doryan-table.csv",skip=6)
 mt3<-read.csv("../results/COMPOTE EffetControleurs180_4_David-table.csv",skip=6) #TODO: David
                 
 colnames(mt1)<-colnames(mt2)<-colnames(mt3)<-c("run","nb_managers", "actionControllers","actionManagers","Controleur_Survey_Capacity_Global","alpha","Diffuse_Risque_Global","Sa_M","Sd_M", "betap","rProd", "Iinit","deltaSa","deltaSd","tpsExtermination", "radiusInfestMax","file_name",  "Sa_C","Sd_C","file_number","step","pct_infected_tot","pct_var1","pct_var2","nb_patchCutted","nb_patchHidded","nb_patchCuttedByC")
 mt1$file_name<- as.character(mt1$file_name)
 mt2$file_name<- as.character(mt2$file_name)
 mt3$file_name<- as.character(mt3$file_name)
 mt<-rbind(mt2,mt3,mt1)
 mt$file_name<-as.factor(mt$file_name)
 levels(mt$file_name)<-c("gem10","gem1000","random","gem10","gem1000","random")
 mt$SpatialModality<-as.numeric(mt$file_name)
 mt$pct_var3<- 1 - (mt$pct_var1 + mt$pct_var2)
 
 mt<-mt[mt$step==450,]
 
 mtslow<-mt[mt$radiusInfestMax == 4,]
 mtquick<-mt[mt$radiusInfestMax == 8,]
 
 boxplot(pct_infected_tot~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt,las=2)
 boxplot(nb_patchCutted~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt)
 boxplot(nb_patchCuttedByC~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt)
 boxplot(nb_patchHidded~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt) 
 boxplot(pct_var1 ~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt)  
 boxplot(pct_var2 ~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt)   
 boxplot(pct_var3 ~radiusInfestMax+tpsExtermination+SpatialModality+Sa_C+Sd_C,data=mt)    
 
 boxplot(pct_infected_tot~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)
 boxplot(nb_patchCutted~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)
 boxplot(nb_patchCuttedByC~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)
 boxplot(nb_patchHidded~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)
 boxplot(pct_var1 ~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)
 boxplot(pct_var2 ~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)
 boxplot(pct_var3 ~SpatialModality+Sa_C+Sd_C,data=mtslow,las=2)

 boxplot(pct_infected_tot~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 boxplot(nb_patchCutted~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 boxplot(nb_patchCuttedByC~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 boxplot(nb_patchHidded~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 boxplot(pct_var1 ~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 boxplot(pct_var2 ~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 boxplot(pct_var3 ~SpatialModality+Sa_C+Sd_C,data=mtquick,las=2)
 
 #3D
 library(rgl)
 plot3d(mt$pct_infected_tot~mt$nb_patchCuttedByC+mt$nb_patchHidded,xlab="Controller",ylab="Cheat Farmer",zlab="Infestation")
 plot3d(mtquick$pct_infected_tot~mtquick$nb_patchCuttedByC+mtquick$nb_patchHidded,xlab="Controller",ylab="Cheat Farmer",zlab="Infestation")  
 
 #?? tester l'effet spatiale sur la proba de réussite de controle?
 
 #Analyse protocole 1   (2 modalités de controleurs)
 
   mg1<-read.csv("../results/SMCI_unilim.csv")#,skip=6) # sans controlleur
   mg1$SpatialModality<-as.numeric(mg1$ifile_name)
   boxplot(infecteTotal~SdM+SaM+SpatialModality+radiusInfestMax+tpsExtermination,data=mg1,las=2)


   #illustration of SpatialModality effect :
   boxplot(infecteTotal~SpatialModality+SaM+SdM,data=mg1[mg1$radiusInfestMax==4 & mg1$tpsExtermination==180 & mg1$deltaSd==0 & mg1$deltaSa==0,],las=2)


   par(mfrow=c(2,5))
   for(sdm in sort(unique(mg1$SaM))){
      boxplot(infecteTotal~SpatialModality+SdM,data=mg1[mg1$radiusInfestMax==4 & mg1$tpsExtermination==180 & mg1$deltaSd==0 & mg1$deltaSa==0 & mg1$SaM==sdm,],las=2,main=paste("Sa=",sdm),xaxt="n",ylim=c(0,0.2))
      axis(1,at=seq(1,12,by=1),labels=rep(c("CC","C","R"),4))
      axis(1,at=c(0.5,seq(2,11,by=3)),labels=c("Sd=",0.1,0.2,0.3,0.4),line=2,lty=0)
      abline(h=mean(mg1[mg1$radiusInfestMax==4 & mg1$tpsExtermination==180 & mg1$deltaSd==0 & mg1$deltaSa==0 & mg1$SaM==sdm,"infecteTotal"]),lty=2,col="gray")
      if(sdm>0.1)lines(c(0,(3*(sdm*10-1))+0.5),c(0.2,0.2),col=2,lwd=2)
   } #effet tricherie apparent quand Sa>Sd
   

   for(sdm in sort(unique(mg1$SaM))){
      boxplot(infecteTotal~SpatialModality+SdM,data=mg1[mg1$radiusInfestMax==8 & mg1$tpsExtermination==30 & mg1$deltaSd==0 & mg1$deltaSa==0 & mg1$SaM==sdm,],las=2,main=paste("Sa=",sdm),xaxt="n",ylim=c(0,1))
      axis(1,at=seq(1,12,by=1),labels=rep(c("CC","C","R"),4))
      axis(1,at=c(0.5,seq(2,11,by=3)),labels=c("Sd=",0.1,0.2,0.3,0.4),line=2,lty=0)
      abline(h=mean(mg1[mg1$radiusInfestMax==8 & mg1$tpsExtermination==30 & mg1$deltaSd==0 & mg1$deltaSa==0 & mg1$SaM==sdm,"infecteTotal"]),lty=2,col="gray")
      if(sdm>0.1)lines(c(0,(3*(sdm*10-1))+0.5),c(1.02,1.02),col=2,lwd=2)
   }   
   
 
   mg2<-read.csv("../results/SMCI_zebulon.csv")#,skip=6) # sans controlleur
   mg2$SpatialModality<-as.numeric(mg2$ifile_name) 
 
    par(mfrow=c(2,5))
   for(sdm in sort(unique(mg2$SaM))){
      boxplot(infecteTotal~SpatialModality+SdM,data=mg2[mg2$radiusInfestMax==4 & mg2$tpsExtermination==180 & mg2$deltaSd==0 & mg2$deltaSa==0 & mg2$SaM==sdm,],las=2,main=paste("Sa=",sdm),xaxt="n",ylim=c(0,0.2))
      axis(1,at=seq(1,12,by=1),labels=rep(c("CC","C","R"),4))
      axis(1,at=c(0.5,seq(2,11,by=3)),labels=c("Sd=",0.1,0.2,0.3,0.4),line=2,lty=0)
      abline(h=mean(mg2[mg2$radiusInfestMax==4 & mg2$tpsExtermination==180 & mg2$deltaSd==0 & mg2$deltaSa==0 & mg2$SaM==sdm,"infecteTotal"]),lty=2,col="gray")
      if(sdm>0.1)lines(c(0,(3*(sdm*10-1))+0.5),c(0.2,0.2),col=2,lwd=2)
   } #effet tricherie apparent quand Sa>Sd
   

   for(sdm in sort(unique(mg2$SaM))){
      boxplot(infecteTotal~SpatialModality+SdM,data=mg2[mg2$radiusInfestMax==8 & mg2$tpsExtermination==30 & mg2$deltaSd==0 & mg2$deltaSa==0 & mg2$SaM==sdm,],las=2,main=paste("Sa=",sdm),xaxt="n",ylim=c(0,1))
      axis(1,at=seq(1,12,by=1),labels=rep(c("CC","C","R"),4))
      axis(1,at=c(0.5,seq(2,11,by=3)),labels=c("Sd=",0.1,0.2,0.3,0.4),line=2,lty=0)
      abline(h=mean(mg2[mg2$radiusInfestMax==8 & mg2$tpsExtermination==30 & mg2$deltaSd==0 & mg2$deltaSa==0 & mg2$SaM==sdm,"infecteTotal"]),lty=2,col="gray")
      if(sdm>0.1)lines(c(0,(3*(sdm*10-1))+0.5),c(1.02,1.02),col=2,lwd=2)
   }





















 
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
