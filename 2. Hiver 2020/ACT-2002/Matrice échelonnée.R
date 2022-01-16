


Mat.Ech <- function(A)
{
    n <- nrow(A)
    i <- 1
    j <- 1
    k <- 1
    X <- A
    while(i <= n^2)
    {
        I <- diag(n)
        if(j == k)
        {
            I[i] <- 1/X[i]
            X <- I %*% X
        }
        if(j > k)
        {
            I[i] <- -X[i]
            X <- I %*% X
        }
        if(j == n) j <- 0
        i <- i + 1
        j <- j + 1
        k <- ceiling(i/n)
    }
    list("Matrice U" = X,
         "Matrice L" = A %*% solve(X))
}
A <- matrix(c(1,3,2,4), nrow = 2)
Mat.Ech(A)

