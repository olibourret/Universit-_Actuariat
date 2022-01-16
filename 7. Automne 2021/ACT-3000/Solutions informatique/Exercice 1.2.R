## ACT-3000
## 1.2.1 Exercices informatiques


### Question 1

## Identifiction des variables utilisées (Un mélange de 2 exponentielles donne une Erlang Généralisée)
beta1 <- 1/10
beta2 <- 1/20
coef1 <- beta1 / (beta2 - beta1)
coef2 <- 1 - coef1

pErlangGeneralisee <- function(x){
    1 - coef1*exp(-beta1*x) - coef2 * exp(-beta2*x)    ## Répartition d'Erlang généralisée
}

kap <- 0.99
pErlangGeneralisee(VaR)

# Calcul de la VaR avec la fonction optimize

f <- function(x){
    abs(pErlangGeneralisee(x) - kap)   ## 
}

resultat <-  optimize(f, c(100,1000))
VaR <- resultat$minimum
c(VaR, pErlangGeneralisee(VaR))

#
#
# Distribution : gamma (Car une somme d'exponentielles avec le même lambda = Gamma(n,lambda))
#
qgamma(kap,2,1/10)
beta3<-2/((1/beta1)+(1/beta2))
beta3
qgamma(kap,2,beta3)
#
# 




