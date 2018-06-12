#fonction de croissance de la production

r<-0.25
Infest<-0
prodMax<-1    
prodt0<-0.1 
prodt1<-NULL     
for(pst in 1:30){
prodt0<-prodt0+r*prodt0*(1-prodt0/(prodMax*(1-Infest)))
prodt1<-c(prodt1,prodt0)
}

plot(1:30,prodt1)

# fonction d'apparition d'infestation   #Logistic TODO

pot<-seq(0,1,length=1000)
alpha<-0.0005
ProbaInfest = 1-alpha^(pot)

plot(pot,ProbaInfest)


# fonction d'integration de potentiels
rmax<-5
sigma<-rmax/2
distance <- seq(0,rmax,length=100)
Infest<-0.01
pott<- Infest * (1/sqrt(2*pi*sigma^2))*exp(-(distance^2 / (2*sigma^2) ))

plot(distance,pott)
