## Exercice Section 1.4
## Distribution de fréquence et FFT


# Exercice 2

# a. E[B]
n <- 2^20
vk0 <- 0:(n-1)
vk1 <- 1:(n-1)
sigma <- 0.8
mu <- log(100)-sigma^2/2
fB <- c(0,plnorm(vk1, mu, sigma) - plnorm(vk1-1, mu, sigma))
EB <- sum(fB*(vk0))

EB

# b. Var(B)

EB2 <- sum((vk0)^2*fB)
VarB <- EB2-EB^2
VarB



# d. 

# Variables
nFFT <- 2^20
lambda <- 1.5
r <- 0.5
q <- 1/4

# Étape 1 : Construction
#fB <- c(0,fB)
fBt <- fft(fB)

# Étape 2 : Agrégation
fXt <- (q^r * exp(lambda*(fBt - 1)))/(1 - (1 - q)*fBt)^r

# Étape 3 : Inversion
fX <- Re(fft(fXt, inverse = TRUE))/nFFT

# Validation
sum(fX)
EX <- sum(fX*vk0)
EX2 <- sum(fX*vk0^2)
VarX <- EX2-EX^2
cbind(EX, VarX)

# Réponse
fX[(0:5)*100+1]


# e. Calculer la VaR_k(X)

VaR.50 <- sum(cumsum(fX)<0.5)
VaR.99<- sum(cumsum(fX)<0.99)
VaR.999<- sum(cumsum(fX)<0.999)
VaR.9999<- sum(cumsum(fX)<0.9999)
cbind(VaR.50,VaR.99,VaR.999,VaR.9999)
