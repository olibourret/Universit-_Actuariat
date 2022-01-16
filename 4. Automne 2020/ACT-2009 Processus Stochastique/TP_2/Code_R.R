### Travail Pratique 2
## ACT-2009 Processus Stochastique
# Équipe 9
# Olivier Bourret
# Marianne Chouinard

# Cération de tableaux et de valeurs pour les paramètres assignés à l'équipe 9.

param_ab <- data.frame("i" = c(1:3),
                       "n_i"= c(35,25,40),
                       "a_i"= c(0,0,0),
                       "b_i"= c(4,5,6),
                       "alpha_i"= c(1,1,1),
                       "beta_i"= c(1.5,2,2.5),
                       "M_i"= c(1500,2500,1000))

Force_int <- 0.02

param_c <- data.frame("i" = c(1:3),
                      "n_i"= c(35,25,40),
                      "theta_i"= c(2,3,4),
                      "lambda_i"= c(0.003,0.004,0.005),
                      "alpha_i"= c(1,1,1),
                      "beta_i"= c(1.5,2,2.5),
                      "M_i"= c(1500,2500,1000))


param_2ecas <- data.frame("mu"= 0.05, "sigma" = 0.1, "force_interet"= 0.02, "k_1"= 115, "k_2"= 127,
                          "T_1"= 1, "T_2"= 2, "lambda"= 0.1, "alpha"= "?", "beta"= 0.5)




essaie <- function(k,t){
  i <- 0
  a <- 0
  b <- 0
  c <- 0
  for(i in 0:k){
    a <- a + (4*t)^i/(factorial(i))
    b <- b + (5*t)^i/(factorial(i))
    c <- c + (6*t)^i/(factorial(i))
    i+1
  }
  5250*k/t * (1-exp(-4*t)*a) + 12500*k/(3*t) * (1-exp(-5*t)*b) + 40000*k/(21*t) * (1-exp(-6*t)*c)
}



essaie(25,10)





### Création de la fonction pour simuler

# Fonction de perte des contrats type 1
Simulation_1 <- function(){

    lambda <- runif(1,0,4)
    T_i <- c()
    X_i <- c()
    S_ik <- c()
    perte <- c()
    temps <- 0
    while(temps<10){
      T_i <- append(T_i, rexp(1,rate = lambda))
      X_i <- append(X_i,rbeta(1, shape1 = 1, shape2 = 1.5))
      S_ik <- append(S_ik, sum(T_i))
      temps <- sum(T_i)
    }
    T_i <- T_i[-length(T_i)]
    S_ik <- S_ik[-length(S_ik)]
    X_i <- X_i[-length(X_i)]
    
    sum(exp(-0.02*S_ik)*1500*X_i)
}


## Fonction de perte des contrats type 2
Simulation_2 <- function(){
  
  lambda <- runif(1,0,5)
  T_i <- c()
  X_i <- c()
  S_ik <- c()
  perte <- c()
  temps <- 0
  while(temps<10){
    T_i <- append(T_i, rexp(1,rate = lambda))
    X_i <- append(X_i,rbeta(1, shape1 = 1, shape2 = 2))
    S_ik <- append(S_ik, sum(T_i))
    temps <- sum(T_i)
  }
  T_i <- T_i[-length(T_i)]
  S_ik <- S_ik[-length(S_ik)]
  X_i <- X_i[-length(X_i)]
  
  sum(exp(-0.02*S_ik)*2500*X_i)
}


## Fonction de perte des contrats type 3
Simulation_3 <- function(){
  
  lambda <- runif(1,0,6)
  T_i <- c()
  X_i <- c()
  S_ik <- c()
  perte <- c()
  temps <- 0
  while(temps<10){
    T_i <- append(T_i, rexp(1,rate = lambda))
    X_i <- append(X_i,rbeta(1, shape1 = 1, shape2 = 2.5))
    S_ik <- append(S_ik, sum(T_i))
    temps <- sum(T_i)
  }
  T_i <- T_i[-length(T_i)]
  S_ik <- S_ik[-length(S_ik)]
  X_i <- X_i[-length(X_i)]
  
  sum(exp(-0.02*S_ik)*1000*X_i)
  
}

## Fonction pour simuler n échantillons
simPerteTot <- function(n){
  i <- 1
  pertetot <- c()
  
  for(i in 1:n){
    a <- sum(replicate(35, Simulation_1()))
    b <- sum(replicate(25, Simulation_2()))
    c <- sum(replicate(40, Simulation_3()))
    pertetot <- append(pertetot,sum(a,b,c))
    i+1
  }
  pertetot
}


simUnif <- simPerteTot(1000)
simUnif



## Quantiles

q05 <- quantile(simUnif,0.05)
q95 <- quantile(simUnif,0.95)
q100 <- quantile(simUnif,1)


## Graphique des simulation
hist(simUnif, probability = TRUE, nclass = 20, col = "azure",
     main = "Distribution des 1000 simulations des pertes",
     xlab = "Perte actualisée (en $)", ylab = "Densité")

abline(v = mean(simUnif), col = "blue4", lty = 2, lwd = 3) # Moyenne
abline(v = q95, col = "green4", lty = 3, lwd = 3)
abline(v = q05, col = "green4", lty = 3, lwd = 3)
  lines(density(simUnif), col = "red4", lwd = 2)

legend("topright", legend = c("Moyenne","VaR à 5% et 95%"),
       col = c("blue4","green4"), lty = c(2,3), lwd = c(3,3))  

x1 <- min(which(density(simUnif)$x >= q95))
x2 <- max(which(density(simUnif)$x <  q100))
with(density(simUnif), polygon(x=c(x[c(x1,x1:x2,x2)]),
                               y= c(0, y[x1:x2], 0), col="red3"))



## VaR et TVaR

VaR <- quantile(simUnif, c(0.9, 0.95, 0.99)) # VaR
VaR
mean(tail(sort(simUnif),100)) # TVaR(90)
mean(tail(sort(simUnif),50)) # TVaR(95)
mean(tail(sort(simUnif),10)) # TVaR(99)


## c) Processus de renouvellement Gamma


## Fonction pour simuler Gamma type 1
SimGamma_1 <- function(){
  
  T_i <- c()
  X_i <- c()
  S_ik <- c()
  perte <- c()
  temps <- 0
  while(temps<10){
    T_i <- append(T_i, rgamma(1, shape = 2, rate = 0.03))  #### Scale ou rate???
    X_i <- append(X_i,rbeta(1, shape1 = 1, shape2 = 1.5))
    S_ik <- append(S_ik, sum(T_i))
    temps <- sum(T_i)
  }
  T_i <- T_i[-length(T_i)]
  S_ik <- S_ik[-length(S_ik)]
  X_i <- X_i[-length(X_i)]
  
  sum(exp(-0.02*S_ik)*1500*X_i)
}

head(param_ab,3,escape = FALSE, 
           col.names = c("$i$", "$n_i$", "$a_i$", "$b_i$", "$\\alpha_i$", "$\\beta_i$", "$M_i$","$\\delta_i$"))

## Fonction pour simuler Gamma type 2
SimGamma_2 <- function(){
  
  T_i <- c()
  X_i <- c()
  S_ik <- c()
  perte <- c()
  temps <- 0
  while(temps<10){
    T_i <- append(T_i, rgamma(1, shape = 3, scale = 0.04))  #### Scale ou rate???
    X_i <- append(X_i,rbeta(1, shape1 = 1, shape2 = 2))
    S_ik <- append(S_ik, sum(T_i))
    temps <- sum(T_i)
  }
  T_i <- T_i[-length(T_i)]
  S_ik <- S_ik[-length(S_ik)]
  X_i <- X_i[-length(X_i)]
  
  sum(exp(-0.02*S_ik)*2500*X_i)
}


## Fonction pour simuler Gamma type 2
SimGamma_3 <- function(){
  
  T_i <- c()
  X_i <- c()
  S_ik <- c()
  perte <- c()
  temps <- 0
  while(temps<10){
    T_i <- append(T_i, rgamma(1, shape = 4, scale = 0.05))  #### Scale ou rate???
    X_i <- append(X_i,rbeta(1, shape1 = 1, shape2 = 2.5))
    S_ik <- append(S_ik, sum(T_i))
    temps <- sum(T_i)
  }
  T_i <- T_i[-length(T_i)]
  S_ik <- S_ik[-length(S_ik)]
  X_i <- X_i[-length(X_i)]
  
  sum(exp(-0.02*S_ik)*1000*X_i)
}


simPerteTotGamma <- function(n){
  i <- 1
  pertetot <- c()
  
  for(i in 1:n){
    a <- sum(replicate(35, SimGamma_1()))
    b <- sum(replicate(25, SimGamma_2()))
    c <- sum(replicate(40, SimGamma_3()))
    pertetot <- append(pertetot,sum(a,b,c))
    i+1
  }
  pertetot
}

simGamma <- simPerteTotGamma(1000)


simGamma


## Graphique des simulation
q05 <- quantile(simGamma,0.05)
q95 <- quantile(simGamma,0.95)
q100 <- quantile(simGamma,1)


hist(simGamma, probability = TRUE, nclass = 20, col = "azure",
     main = "Distribution des 1000 simulations des pertes",
     xlab = "Perte actualisée (en $)", ylab = "Densité")

abline(v = mean(simGamma), col = "blue4", lty = 2, lwd = 3) # Moyenne
abline(v = q05, col = "green4", lty = 3, lwd = 3)
abline(v = q95, col = "green4", lty = 3, lwd = 3)
lines(density(simGamma), col = "red4", lwd = 2)

legend("topright", legend = c("Moyenne","VaR à 5% et 95%"),
       col = c("blue4","green4"), lty = c(2,3), lwd = c(3,3)) 


x1 <- min(which(density(simGamma)$x >= q95))
x2 <- max(which(density(simGamma)$x <  q100))
with(density(simGamma), polygon(x=c(x[c(x1,x1:x2,x2)]),
                                y= c(0, y[x1:x2], 0), col="red3"))

## VaR et TVaR

quantile(simGamma, c(0.9, 0.95, 0.99)) # VaR

mean(tail(sort(simGamma),100)) # TVaR(90)
mean(tail(sort(simGamma),50)) # TVaR(95)
mean(tail(sort(simGamma),10)) # TVaR(99)







## NUMÉRO 2



# a) Approximation des prix d'option à l'aide de 1000 simulations

# Si Z(t) ~ un mouvement Brownien standard, alors Z(t) ~ N(0,t). On a juste à générer aléatoirement des variables d'une normale
# et ensuite l'appliquer dans la formule pour trouver la valeur de l'action au temps t.


# Fonction qui calcule la valeur de l'action selon mu, sigma au temps t
valAction <- function(mu,sigma,t){              ######EST_CE QUE C'EST T ou T^.5?????
  S_t <- 100 * exp(mu*t + sigma*rnorm(1,0,t))
  S_t
}

simEuroK1T1 <- replicate(1000,max(0,valAction(0.05,0.1,1)-115))
simEuroK2T1 <- replicate(1000,max(0,valAction(0.05,0.1,1)-127))
simEuroK1T2 <- replicate(1000,max(0,valAction(0.05,0.1,2)-115))
simEuroK2T2 <- replicate(1000,max(0,valAction(0.05,0.1,2)-127))

# Prix de l'option en fonction de T et K.

# NOTE: J'ai fait la moyenne des simulation, afin d'obtenir le gain moyen du coût d'option
prixAchatEuroK1T1 <- exp(-0.02*1)*mean(simEuroK1T1)
prixAchatEuroK2T1 <- exp(-0.02*1)*mean(simEuroK2T1)
prixAchatEuroK1T2 <- exp(-0.02*2)*mean(simEuroK1T2)
prixAchatEuroK2T2 <- exp(-0.02*2)*mean(simEuroK2T2)


# Fonction pour calculer S_t en fonction de S_{t-1}

sautPeriode <- function(mu,sigma,t){
  S_t1 <- 100 * exp(mu*t + sigma*rnorm(1,0,t-1))
  S_t2 <- S_t1 * exp(mu + sigma*rnorm(1,0,1))
  T1 <- max(0,S_t1-115)
  T2 <- max(0,S_t2-127)
  tableau <- data.frame("S_t1" = S_t1,
                        "S_t2" = S_t2,
                        "Gain pour T1" = T1,
                        "Gain pour T2" = T2,
                        "Gain total" = T1+T2)
  tableau
}
sautPeriode(0.05,0.1,2)


##### Coût de l'Option exotique

# Fonction pour calculer l'option exotique
optExotic <- function(n){
  i <- 1
  Option <- data.frame("S_t1" = numeric(n),
                       "S_t2" = numeric(n),
                       "Gain pour T1" = numeric(n),
                       "Gain pour T2" = numeric(n),
                       "Gain total" = numeric(n))
  
  for(i in 1:n){
    Option[i,] <- sautPeriode(0.05,0.1,2)
    
  }
   Option
}

simOptExo <- optExotic(1000)
simOptExo


# Cout de l'option exotique (Valeur actualisé de la moyenne)

prixAchatExo <- mean(exp(-0.02*1)*simOptExo[,3] + exp(-0.02*2)*simOptExo[,4])  ###### Est-ce que je dois actualiser à T1 et T2?

prixAchatExo


####### b) VaR du profit


# Calcul des profits
profitEuro <- exp(-0.02*1)*simEuroK1T1 - prixAchatEuroK1T1
profitEuro
profitExo <- exp(-0.02*1)*simOptExo[,3] + exp(-0.02*2)*simOptExo[,4]-prixAchatExo
profitExo


# VaR(95) et VaR(5)

VaR95Euro <- tail(sort(profitEuro), 50)
VaR95Euro
VaR5Euro <- head(sort(profitEuro),50)
VaR5Euro

VaR95Exo <- tail(sort(profitExo), 50)
VaR95Exo
VaR5Exo <- head(sort(profitExo),50)
VaR5Exo

profitExo
## Histogrammes

hist(profitEuro)
abline(v = mean(profitEuro), col= "blue4", lwd = 4, lty = 2)


hist(profitExo, prob=TRUE)
abline(v = mean(profitExo), col= "blue4", lwd = 4, lty = 2)











### e)

## Simulation d'un scénario pour atteindre beta


SimRendement <- function(){
  t <- 0
  T_i <- c()
  temps <- 0
  rendement <- 1
  while(rendement<1.5){
    if(temps<=0){
      temps <- temps+rexp(1,0.1)
    }
    
    temps <- temps-1/365
    if(temps<=0){
      rendement <- rendement*exp(0.05*(1/365)+0.1*rnorm(1,0,sqrt(1/365))+runif(1,-0.215,0))
    }
    else{
      rendement <- rendement*exp(0.05*(1/365)+0.1*rnorm(1,0,sqrt(1/365)))
    }
    t <- t+1/365
  }
  
t

}

SimTemps <- sort(replicate(100,SimRendement()))
mean(SimTemps)



## Quantile, moyenne et histogramme

hist(SimTemps, nclass = 50, xlab = "Temps (en années)",ylab = "Fréquence",
     main = "Distribution des 1000 siumlations pour voir un rendement de 50%")
abline(v = mean(SimTemps), col= "blue4", lwd = 2, lty = 2)
abline(v = mean(SimTemps)+sd(SimTemps), col= "orange", lwd = 2, lty = 2)
abline(v = mean(SimTemps)-sd(SimTemps), col= "orange", lwd = 2, lty = 2)
abline(v = quantile(SimTemps,c(0.01,0.05,0.1,0.9,0.95,0.99)), col= "green4", lwd = 2, lty = 2)



