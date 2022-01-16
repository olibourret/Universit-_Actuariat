### TP1 ACT-2001
### Olivier Bourret


## Numéro 4

# Simulation et tri des 10 000 réalisations de M

simul <- sort(rgeom(10000, prob = 0.1))

# Calcul de la VaR_p(M) pour p = {0.9, 0.99}            

VaR90 <- simul[9000]
VaR99 <- simul[9900]

# Calcul de la TVaR_p(M) pour p = {0.9, 0.99}

TVaR90 <- mean(simul[9001:10000])   
TVaR99 <- mean(simul[9901:10000])





## Numéro 5

# Simulation des 10 000 valeurs de Z
X <- rgamma(10000, shape = 3, rate = 0.05)
Y <- rweibull(10000,shape = 3,scale = 1/0.1)
Z <- X+Y

# Espérance de Z

Es_Z <- mean(Z)          

# Espérance de la fonction stop loss pour d = 20

EsSL_Z <- mean(pmax(Z-20,0))     

# Espérance de l'excès moyen pour d = 20

EsEM_Z <- sum(pmax(Z-20,0))/sum((Z-20)>0)

# Espérance limitée à u = 100

EsLim_Z <- mean(pmin(Z,100))     




