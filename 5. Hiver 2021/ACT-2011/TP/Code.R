library(actuar)

## Arbre binomial

## Arbre binomial

Arbre <- function(S_0, n, K, r, sigma,Option){
    
    u <- exp(r/n + sigma*sqrt(1/n))
    d <- exp(r/n - sigma*sqrt(1/n))
    p <- (exp(r/n) - d)/(u - d)
    ## Calcul de la valeur à chaque noeud
    
    i <- 1
    noeuds <- S_0
    for(i in 1:n){
        j <- 0
        for(j in 0:i){
            noeuds <- cbind(noeuds, S_0*u^(i-j)*d^(j))    ##Calcul de toutes les combinaisons Sud
            j <- j+1
        }
        i+1
    }
    
    ## Cas de l'option d'achat
    
    # Calcul de la valeur de l'option d'achat. Par de la fin pour trouver les valeurs du max(0, S_n - K)
    # pour chaque valeur de fin de l'arbre
    if(Option == "C"){
        i <- length(noeuds)
        Call <- rep(0, length(noeuds))
        for(i in ((n*(n+1)/2)+1):((n+1)*(n+2)/2)){
            Call[i] <- max(noeuds[i]-K,0)
            i <- i-1
        }
        
        #Permet de trouver la valeur de C_i en fonction des autres C_j
        
        i <- (n*(n+1)/2)
        j <- rep(1:n, 1:n)
        for(i in (n*(n+1)/2):1){
            Call[i] <- (p*Call[i+j[i]] + (1-p)*Call[1+i+j[i]])*exp(-r/n)
            i <- i-1
        } 
        resultat <- rbind(noeuds, Call)
        
        # Calcul des delta et des B pour répliquer le portefeuille
        i <- 1
        delta <- rep(NA, length(noeuds))
        B <- rep(NA, length(noeuds))  ### BESOIN DU H DANS LE B???
        for(i in 1:(n*(n+1)/2)){
            delta[i] <- (Call[i+j[i]] - Call[1+i+j[i]])/(noeuds[i+j[i]] - noeuds[1+i+j[i]])
            B[i] <- exp(-r/n)*(noeuds[i+j[i]] * Call[1+i+j[i]] - noeuds[1+i+j[i]] * Call[i+j[i]])/(noeuds[i+j[i]] - noeuds[1+i+j[i]])
            i <- i+1
        }
        resultat <- rbind(resultat, delta)
        resultat <- rbind(resultat, B)
    }
    
    ## Cas de l'option de vente
    
    # Les étapes sont semblables à celle de l'option d'achat
    
    if(Option == "P"){
        i <- length(noeuds)
        Put <- rep(0, length(noeuds))
        for(i in ((n*(n+1)/2)+1):((n+1)*(n+2)/2)){
            Put[i] <- max(K - noeuds[i],0)
            i <- i-1
        }
        
        i <- (n*(n+1)/2)
        j <- rep(1:n, 1:n)
        for(i in (n*(n+1)/2):1){
            Put[i] <- (p*Put[i+j[i]] + (1-p)*Put[1+i+j[i]])*exp(-r/n)
            i <- i-1
        } 
        resultat <- rbind(noeuds, Put)
        
        i <- 1
        delta <- rep(NA, length(noeuds))
        B <- rep(NA, length(noeuds))  ### BESOIN DU H DANS LE B???
        for(i in 1:(n*(n+1)/2)){
            delta[i] <- (Put[i+j[i]] - Put[1+i+j[i]])/(noeuds[i+j[i]] - noeuds[1+i+j[i]])
            B[i] <- exp(-r/n)*(noeuds[i+j[i]] * Put[1+i+j[i]] - noeuds[1+i+j[i]] * Put[i+j[i]])/(noeuds[i+j[i]] - noeuds[1+i+j[i]])
            i <- i+1
        }
        resultat <- rbind(resultat, delta)
        resultat <- rbind(resultat, B)
    }
    resultat
}

Option_Achat <- Arbre(100, 3,K = 110, 0.0100394357940959, 0.0577483885, Option = "C")
Option_Vente <- Arbre(41, 3,K = 40, 0.08, 0.3, Option = "P")
Option_Achattest <- Arbre(41, 3,K = 40, 0.08, 0.3, Option = "C")
Option_Ventetest <- Arbre(100, 4,K = 110, 0.0100394357940959, 0.057483885, Option = "P")

### Question 3


Valeur_Call <- function(K){
    Resultat <- Arbre(S_0=100, n=100,K, u, d, p,force_r,Option = "C")[2,1]  
    Resultat
} 

Valeur_Put <- function(K){
    Resultat <- Arbre(S_0=100, n=100,K, u, d, p,force_r,Option = "P")[2,1]  
    Resultat
} 

Prix_exercice <- c(40*(0:15))
Prix_Call <- sapply(Prix_exercice, FUN = Valeur_Call)
Prix_Put <- sapply(Prix_exercice, FUN = Valeur_Put)

plot(Prix_exercice,Prix_Call, main="Relation entre le prix d'exercice et le prix de l'option",
     xlab="Prix d'exercice ", ylab="Prix de l'option", ylim = range(c(0,100)),pch = 20, col = "blue4")
par(new = TRUE)
plot(Prix_exercice,Prix_Put, ylim= range(c(0,100)), xlab = "", ylab = "", pch = 20, col = "green3")
lines(Prix_exercice,Prix_Put, ylim= range(c(0,100)), col = "green3")
lines(Prix_exercice,Prix_Call, ylim= range(c(0,100)), col = "blue4")
legend("topright", legend=c("Option d'achat", "Option de vente"),
       col=c("blue4", "green3"), lty=c(1,1), lwd = c(2,2), cex=0.8,bg="white")







### Question 4


Arbre_Ame <- function(S_0, n, K, r, sigma){
    
    u <- exp(r/n + sigma*(1/n)^{0.5})
    d <- exp(r/n - sigma*sqrt(1/n))
    p <- (exp(r/n) - d)/(u - d)
    ## Calcul de la valeur à chaque noeud
    
    i <- 1
    noeuds <- S_0
    for(i in 1:n){
        j <- 0
        for(j in 0:i){
            noeuds <- cbind(noeuds, S_0*u^(i-j)*d^(j))
            j <- j+1
        }
        i+1
    }
    
        i <- length(noeuds)
        Put <- rep(0, length(noeuds))
        for(i in ((n*(n+1)/2)+1):((n+1)*(n+2)/2)){
            Put[i] <- max(K - noeuds[i],0)
            i <- i-1
        }
        
        i <- (n*(n+1)/2)
        j <- rep(1:n, 1:n)
        for(i in (n*(n+1)/2):1){
            Put[i] <- max((p*Put[i+j[i]] + (1-p)*Put[1+i+j[i]])*exp(-r/n), K-noeuds[i])
            i <- i-1
        } 
        resultat <- rbind(noeuds, Put)
        
        i <- 1
        delta <- rep(NA, length(noeuds))
        B <- rep(NA, length(noeuds))
        for(i in 1:(n*(n+1)/2)){
            delta[i] <- (Put[i+j[i]] - Put[1+i+j[i]])/(noeuds[i+j[i]] - noeuds[1+i+j[i]])
            B[i] <- exp(-r/n)*(noeuds[i+j[i]] * Put[1+i+j[i]] - noeuds[1+i+j[i]] * Put[i+j[i]])/(noeuds[i+j[i]] - noeuds[1+i+j[i]])
            i <- i+1
        }
        resultat <- rbind(resultat, delta)
        resultat <- rbind(resultat, B)
    resultat
}


Arbre_Ame(41, 3, 40, 0.08, 0.3)

Option_Achat <- Arbre(100, 4,K = 110, force_r, sigma, Option = "C")
Option_Vente <- Arbre(100, 4,K = 95, force_r, sigma, Option = "P")










