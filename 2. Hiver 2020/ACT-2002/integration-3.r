## Sprint de codage 3 - Partie 1
## Noms : Olivier Bourret, Félix Laflamme, William Perron et Simon Veilleux

## Intégration numérique

###
### Simpson(FUN, lower, upper, subdivisions = 1000)
###
##  Évaluer une intégrale définie par la méthode de Simpson.
##
##  Arguments
##
##  FUN : Fonction à intégrer.
##  lower : Borne d'intégration inférieure.
##  upper : Borne d'intégration supérieure.
##  subdivisions : Nombre de divisions de l'aire sous la courbe, détermine 
##                 la précision de l'intégration et vaut 1000 par défaut.
## 
## Valeur
##
## Nombre réel fournissant une estimation de la valeur de l'intégrale.
##
## Exemples
##
## f <- function(x) x^2 * log(x)
## simpson(f, 1, 1.5, subdivisions = 100)
##

simpson <- function(FUN, lower, upper, subdivisions = 1000)
{
    if (upper < lower)
        stop("La borne lower doit être inférieure à la borne upper")
    if (identical(lower, upper))
        return(0)
    h <- (upper - lower) / (2 * subdivisions)
    h / 3 * (FUN(lower) 
             + 2 * sum(FUN(lower + 2 * h * seq(subdivisions - 1))) 
             + 4 * sum(FUN(lower + h * (2 * seq(subdivisions) - 1))) 
             + FUN(upper))
}

# Utiliser la fonction simpson pour calculer l'aire d'intégration de la 
# loi normale (dnorm) de 0 à 1.84 puis multiplier par 2 pour obtenir 
# le niveau de confiance bilatéral.

(ICsimp <- 2 * simpson(dnorm, 0, 1.84))

## Intégration monte-carlo

x <- runif(1e6, 0, 1.84)
(ICmc <- 2 * 1.84 / 1e6 * sum(dnorm(x)))

## Fonction R "integrate"

(ICint <- integrate(dnorm, -1.84, 1.84)[[1]])

## Fonction R "pnorm"

(ICpn <- 2 * pnorm(1.84) - 1)






