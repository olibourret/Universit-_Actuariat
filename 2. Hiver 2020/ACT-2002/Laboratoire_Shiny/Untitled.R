library(polynom)
library(actuar)

install.packages("shiny")

library(shiny)

runExample("01_hello")
runApp("shortfall")
runApp("TCL")
runExample("04_mpg")



x[2]
n <- 100000
i <- 1
x <- numeric(n)
repeat{
    if(i > n)
        break
    x[i] <- mean(rnorm(100, 0, 1))
    i <- i + 1
    
}

min(x)
max(x)


x <- replicate(1000, mean(rnorm(100, 0, 1)))

hist(x, col = "white", xlab = "data()", ylab = "Frequency", main = "Histogram of data()")











