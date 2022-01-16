


### Question 1

# b)
x <- c(3,6,10,5,2,25,7,8,10,32)
y <- c(41185,47917,57675,49789,41595,96901,53840,57712,58027,111762)
plot(x,y, xlab = "Années d'expérience", ylab = "Salaire annuel ($)")


# e)

X_bar <- mean(x)
Y_bar <- mean(y)
S_xx <- sum(x^2)-length(x)*X_bar^2
S_xy <- sum(x*y)-length(x)*X_bar*Y_bar

beta_1 <- S_xy/S_xx
beta_0 <- Y_bar-beta_1*X_bar

abline(a=beta_0,b = beta_1, col = "red")
points(X_bar,Y_bar, col= "green")
SST <- sum((y-Y_bar)^2)
s_2 <- SST/(length(y)-1)

Var_Beta0 <- s_2/length(y)+(Y_bar^2*s_2)/SST
Var_Beta0

Var_Beta1 <- s_2/SST
reg <- lm(x~y)
summary(reg)
