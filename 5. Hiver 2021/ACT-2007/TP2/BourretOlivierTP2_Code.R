


## Question 2

# a)


Kolmo <- function(t){
    P_00 <- 1
    P_01 <- 0
    P_02 <- 0
    h <- 1/12
    i <- 1
    a1 <- 4E-4
    a2 <- 5E-4
    b1 <- 3.4674E-6
    b2 <- 7.5858E-5
    c1 <- 0.138155
    c2 <- 0.087498
    for(i in 0:(t/h-1)){
        x <- (-(a1 + b1 * exp(c1 * (60 + h*i)) + a2 + b2 * exp(c2 * (60 + h*i)))* P_00 + 0.1*(a1 + b1 * exp(c1 * (60 + h*i))) * P_01)*h + P_00
        y <- ((a1 + b1 * exp(c1 * (60 + h*i))) * P_00 - (0.1 * (a1 + b1 * exp(c1 * (60 + h*i))) + a2 + b2 * exp(c2 * (60 + h*i)))* P_01) * h + P_01
        z <- ((a2 + b2 * exp(c2 * (60 + h*i)))* P_00 + (a2 + b2 * exp(c2 * (60 + h*i)))* P_01) *h + P_02
        P_00 <- x
        P_01 <- y
        P_02 <- z
        i <- i+1
    }
    resultat <- c(P_00, P_01, P_02)
    resultat
}

Kolmo(10)

