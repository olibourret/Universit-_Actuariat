## Exercice Section 1.4
## Distribution de fréquence et FFT


# Exercice 1

# f) i. Trouver les valeurs de F_M avec la convolution


lambda <- 1.5
r <- 0.5
q <- 1/4
vk <- 0:10
fk1 <- dpois(vk,lambda)
fk2 <- dnbinom(vk, r, q)


directconvo<-function(ff1,ff2)
{
    # convolution de deux fns de masses de probabilité
    l1<-length(ff1)
    l2<-length(ff2)
    ffs<-ff1[1]*ff2[1]
    smax<-l1+l2-2
    ff1<-c(ff1,rep(0,smax-l1+1)) 
    ff2<-c(ff2,rep(0,smax-l2+1))
    for (i in 1 :smax)
    {
        j<-i+1
        ffs<-c(ffs,sum(ff1[1 :j]*ff2[j :1]))
    }
    return(ffs)
}


reponse <- round(directconvo(fk1,fk2),6)

# ii. Refaire l'exercice, mais avec fft

# Variables
nFFT <- 2^20
vk <- 0:(nFFT-1)
lambda <- 1.5
r <- 0.5
q <- 1/4


# Étape 1 : Construction
fK1 <- dpois(vk, lambda)
fK2 <- dnbinom(vk,r,q)

fK1t <- fft(fK1)
fK2t <- fft(fK2)

# Étape 2 : Agrégration
fMt <- fK1t*fK2t

# Étape 3 : Inversion
fM <- Re(fft(fMt, inverse = TRUE))/nFFT

reponse <- round(fM,6)[0:10]

