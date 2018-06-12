#fonction de croissance de la production     #croissance logistique

r<-0.25
Infest<-0
prodMax<-1    
prodt0<-0.1 
prodt1<-NULL     
for(pst in 1:30){
prodt0<-prodt0+r*prodt0*(1-prodt0/(prodMax*(1-Infest)))
prodt1<-c(prodt1,prodt0)
}

plot(1:30,prodt1,type="l")

# fonction Logistique de probabilité d'apparition d'infestation  et de  valeur d'infestation

pot<-seq(0,10,length=1000)
alpha<-10
betap<-0.5
ProbaInfest =  pot/(1+ exp(-( alpha*(pot-betap))))
ProbaInfest[ProbaInfest>1]<-1

plot(pot,ProbaInfest,type="l")


# fonction d'integration de potentiels
rmax<-2
sigma<-rmax/2
distance <- seq(0,rmax,length=100)
Infest<-0.01
pott<- Infest * 1/rmax * (1/sqrt(2*pi*sigma^2))*exp(-(distance^2 / (2*sigma^2) ))

plot(distance,pott,type="l")
