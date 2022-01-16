#### Fonctions créées pour le cour de GRF2



### Formule de Black-Scholes

##Utilité
# Permet de calculer la valeur de l'option d'achat ou de vente

# Variables
# S = Valeur du sous-jacent
# K = Prix d'exercice
# sigma = écart-type du sous-jacent
# r = force d'intérêt sans risque
# t = temps avant l'échéance
# delta = force de dividende du sous-jacant
# option = "C" pour CALL ou "P" PUT


Option <- function(S,K,sigma,r,t,delta, option){
    d1 <- (log(S/K)+(r-delta+sigma^2/2)*t)/(sigma*sqrt(t))
    d2 <- d1-sigma*sqrt(t)
    if(option == "C"){
        resultat <- S*exp(-delta*t)*pnorm(d1)-K*exp(-r*t)*pnorm(d2)
    }
    if(option == "P"){
        resultat <- -S*exp(-delta*t)*pnorm(-d1)+K*exp(-r*t)*pnorm(-d2)
    }
    resultat
}

Option(28,40,0.3,0.08,1,0,option = "C")




### Gap Option (Option avec écarts)

GapOption <- function(S,K1,K2,sigma,r,t,delta,option){
    d1 <- (log(S/K2)+(r-delta+sigma^2/2)*t)/(sigma*sqrt(t))
    d2 <- d1-sigma*sqrt(t)
    if(option == "C"){
        resultat <- S*exp(-delta*t)*pnorm(d1)-K1*exp(-r*t)*pnorm(d2)
    }
    if(option == "P"){
        resultat <- -S*exp(-delta*t)*pnorm(-d1)+K1*exp(-r*t)*pnorm(-d2)
    }
    resultat
}

GapOption(85,95,100,0.3,0.08,1,0,option = "P")

