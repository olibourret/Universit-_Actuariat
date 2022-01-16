### Sprint de codage 2

irr <- function(x)
{
    if(all(x >= 0) | all(x <=0))
    stop('Tous les flux financiers sont du même signe')
    
    if(sum(abs(Im(polyroot(x))) < .Machine$double.eps^0.5) > 1)
        warning("Plus d'un changement de signe dans les flux nets, le taux de rendement peut ne pas être unique")
   
    i <- (Re(polyroot(x))[abs(Im(polyroot(x))) < .Machine$double.eps^0.5])^(-1) - 1
    
   i[i > -1]
}



