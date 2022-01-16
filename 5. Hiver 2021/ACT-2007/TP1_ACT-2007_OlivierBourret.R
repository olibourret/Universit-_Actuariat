### TP 1 ACT-2007
### Olivier Bourret


library(tidyverse)

## Numéro 1

# Fonction pour calculer la force de mortalité lorsque s > 2

f_Mort <- function(x){
    0.00022+(2.7)*10^(-6)*1.124^x
}
f_Mort(59.99)


# Fonction récursive pour calculer la valeur de la réserve à t

reserve_Euler <- function(h, reserve, t){
    i <- 1
    nb_iter <- (30-t)/h
    for(i in 1:nb_iter){
        reserve <- (reserve - h*(2500 - 100000*f_Mort(60 - (i)*h)))/(1 + h*(0.04 + f_Mort(60 - (i)*h)))
        i <- i+1
    }
    reserve
}


reserve_Euler(0.1, 100000, 29.99)   ### Pour 15_V, h = 0.1   
reserve_Euler(0.1, 100000, 20)   ### Pour 20_V, h = 0.1
reserve_Euler(0.01, 100000, 15)   ### Pour 15_V, h = 0.01   
reserve_Euler(0.01, 100000, 20)   ### Pour 20_V, h = 0.01    
    
    

## Numéro 3

# Graphique de la perte


ggplot(data.frame(x = c(0,50)), aes(x = x)) +
           stat_function(fun = function(x){
               -3802.09 * ((1-exp(-0.06*(x-10)))/0.06)
               },
               color = "blue3",
               lwd = 1, 
               xlim = c(10,20)) +
           stat_function(fun = function(x){
               20000 * exp(-0.6) * ((1-exp(-0.06 *(x-20)))/0.06) - 3802.09 * ((1-exp(-0.06*10))/0.06)
               },
               color = "green4",
               lwd = 1,
               xlim = c(20,60)) +
            stat_function(fun = function(x){-10000},
                          color = "orange1",
                          lwd = 1,
                          lty = 2,
                          xlim = c(0,60)) + ggtitle("Pertes _10L") +
    xlab("T45") +
    ylab("Perte ($)") +
    theme(axis.line = element_line(colour = "black", size = 1, linetype = "solid"))


## Numéro 6

# Fonction pour calculer t_p_x

tpx <- function(x,t){
    A <- 0.00022
    B <- 2.7*10^(-6)
    c <- 1.124
    exp(-A*t - (B/log(c))*(c^x)*((c^t)-1))
}
tpx(20,1)

# Fonction pour calculer une assurance temporaire (ou entière)

aTempo <- function(x, t, i){
    j <- 0
    nb_iter <- t-1
    Assurance <- 0
    for(j in 0:nb_iter){
        Assurance <- Assurance + (1+i)^(-(j+1))*tpx(x,j)*(1-tpx(x+j,1))
        j <- j+1
    }
    Assurance
}

aTempo(25, 1000, 0.05) ### Pour i = 5%
aTempo(22, 1000, 0.02) ### Pour i = 2%



# Fonction pour calculer une rente

rTemp <- function(x, t, i){
    v <- (1+i)^(-1)
    j <- 0
    nb_iter <- t-1
    rente <- 0
    for(j in 0:nb_iter){
        rente <- rente + v^j * tpx(x,j)
        j <- j+1
    }
    rente
}

rTemp(25,1000, 0.05)

     
