### Code TP2 ACT-2001
## Olivier Bourret

library(actuar)

# Question 2
# a)

## Calcul de Pr(S>1000)
j <- c(0:180)
exp(-0.05 *1000)*sum((0.05 * 1000)^(j)/factorial(j))

sum(1:20)
qgamma(1000, shape = 210, rate = 0.05)
qpois(209,0.05*1000)
ppois(209,0.05*1000)
factorial(210)

### b)

pnorm(11.04104893)


## Question 3

B_1 <- rgamma(100000, 2, 0.05)
B_2 <- rgamma(100000, 2, 0.05)

B1B2 <- sum(((B_1 + B_2)<40)*1)/100000


pgamma(40, 4,0.05)




## Question 4

# Simulation des 100000 réalisations pour les X_i
BinComp_sim <- rcompound(100000, rbinom(2,0.5), rpareto(3,600))
PoiComp_sim <- rcomppois(100000, 2, rgamma(3,0.01))
BinNegComp_sim <- rcompound(100000, rnbinom(2,0.5), rlnorm(4,2))


# Calcul de E[X_i]
Esp_X1 <- mean(BinComp_sim)
Esp_X2 <- mean(PoiComp_sim)
Esp_X3 <- mean(BinNegComp_sim)


# Calcul de la Var(X_i)
Var_X1 <- var(BinComp_sim)
Var_X2 <- var(PoiComp_sim)
Var_X3 <- var(BinNegComp_sim)


# b) Calcul de la fonction stop-loss avec d=200

# Calcule de la fonction stop-loss
EsSL_X1 <- mean(pmax(BinComp_sim-200,0))
EsSL_X2 <- mean(pmax(PoiComp_sim-200,0))
EsSL_X3 <- mean(pmax(BinNegComp_sim-200,0))


# c) VaR et TVaR

VaR90_X1 <- sort(BinComp_sim)[90000]
VaR90_X2 <- sort(PoiComp_sim)[90000]
VaR90_X3 <- sort(BinNegComp_sim)[90000]

TVaR90_X1 <- mean(sort(BinComp_sim)[90001:100000])
TVaR90_X2 <- mean(sort(PoiComp_sim)[90001:100000])
TVaR90_X3 <- mean(sort(BinNegComp_sim)[90001:100000])


# d) Avec S

S <- BinComp_sim + PoiComp_sim + BinNegComp_sim

EsSL_S <- mean(pmax(S-600,0))
VaR90_S <- sort(S)[90000]
TVaR90_S <- mean(sort(S)[90001:100000])



