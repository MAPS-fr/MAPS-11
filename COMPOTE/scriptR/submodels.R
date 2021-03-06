#fonction de croissance de la production     #croissance logistique

r<-0.25
Infest<-0.2
prodMax<-1    
prodt0<-0.1 
prodt1<-NULL     
for(pst in 1:30){
  prodt0<-prodt0+r*prodt0*(1-prodt0/(prodMax*(1-Infest)))
  prodt1<-c(prodt1,prodt0)
}

plot(1:30,prodt1,type="l")

#fonction de croissance de la maladie #forme lin�aire:

Infest0<-0.01
tpsExtermination<-100
Si<-0.9
rI<- Si * 1/ tpsExtermination
Infest1<-NULL
for(pst in 1:31)
{
  Infest0<-Infest0 + rI
  if(Infest0>1)Infest0<-1
  Infest1<-c(Infest1,Infest0)
}
plot(1:31,Infest1,type="l")


# fonction d'integration de potentiels
rmax<-5
sigma<-rmax/2
distance <- seq(0,rmax,length=100)
Infest<-0.01
pott<- Infest * exp(-(distance^2 / (2*sigma^2) ))    #  (1/sqrt(2*pi*sigma^2))

plot(distance,pott,type="l")
# fonction Logistique de probabilit� d'apparition d'infestation  et de  valeur d'infestation

pot<-seq(0,1,length=1000)
alpha<-1
betap<-0.5
ProbaInfest =  pot/((1+ exp(-( alpha*(pot-betap)))) * rmax^2)
ProbaInfest[ProbaInfest>1]<-1

plot(pot,ProbaInfest,type="l")



