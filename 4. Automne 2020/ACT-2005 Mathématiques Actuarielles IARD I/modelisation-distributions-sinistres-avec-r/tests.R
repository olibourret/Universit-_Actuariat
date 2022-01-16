### Emacs: -*- coding: utf-8; fill-column: 65; comment-column: 30; -*-
##
## Copyright (C) 2018 Vincent Goulet
##
## Ce fichier fait partie du projet
## «Modélisation des distributions de sinistres avec R»
## https://gitlab.com/vigou3/modelisation-distributions-sinistres-avec-r
##
## Cette création est mise à disposition selon le contrat
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## https://creativecommons.org/licenses/by-sa/4.0/

###
### TESTS GRAPHIQUES
###

## EXEMPLE 6.1
##
## Comparaison des courbes empiriques et théoriques d'un modèle
## pour un petit échantillon de données.
x <- c(30, 38, 34, 29, 35, 34, 29, 39, 20, 37,
       21, 27, 37, 18, 37, 34, 17, 28, 38, 32)

## Le package MASS est nécessaire pour le calcul des EMV.
library(MASS)

## On ajuste des lois gamma et log-normale à ces données par la
## méthode du maximum de vraisemblance.
(fit.g <- fitdistr(x, "gamma")$estimate)
(fit.ln <- fitdistr(x, "lognormal")$estimate)

## Comparaison entre la fonction de répartition empirique et les
## fonctions de répartition théoriques des deux modèles. La façon
## la plus simple de tracer ces dernières est généralement avec
## la fonction 'curve'.
plot(ecdf(x))
curve(pgamma(x, fit.g[1], fit.g[2]), add = TRUE,
      lwd = 2, col = "darkblue")
curve(plnorm(x, fit.ln[1], fit.ln[2]), add = TRUE,
      lwd = 2, col = "darkred")

## Même idée avec l'histogramme et les fonctions de densité. Si
## les classes sont égales dans l'histogramme, ne pas oublier
## d'ajouter l'option 'prob = TRUE' dans l'appel de 'hist'.
hist(x, breaks = c(0, 20, 25, 28, 30, 32, 34, 37, 40))
curve(dgamma(x, fit.g[1], fit.g[2]), add = TRUE,
      lwd = 2, col = "darkblue")
curve(dlnorm(x, fit.ln[1], fit.ln[2]), add = TRUE,
      lwd = 2, col = "darkred")


## EXEMPLE 6.2
##
## On ajuste des distributions exponentielle et log-normale à un
## petit échantillon par la méthode du maximum de vraisemblance
## et on compare leur ajustement avec des graphiques
## quantile-quantile.
x <- c(10, 12, 13, 15, 18, 20, 22, 23, 29)
(fit.e <- fitdistr(x, "exponential")$estimate)
(fit.ln <- fitdistr(x, "lognormal")$estimate)

## La fonction 'ppoints' calcule les points où l'on évaluera la
## fonction de quantile théorique. Par défaut, a = 3/8 si le
## nombre de données est inférieur ou égal à 10 (comme c'est le
## cas ici) et a = 1/2 sinon. On peut fixer la valeur de a
## nous-mêmes.
(y <- ppoints(length(x)))               # avec 'ppoints'
(seq_along(x) - 3/8)/(length(x) + 0.25) # idem

## La fonction 'qqnorm' trace un graphique quantile-quantile pour
## des données normales. De manière plus générale, 'qqplot' trace
## un graphique quantile-quantile entre deux jeux de données.
## Pour nos besoins, il suffit de lui fournir les données et les
## quantiles théoriques.
##
## On commence avec le graphique de la log-normale.
qqplot(qlnorm(y, fit.ln[1], fit.ln[2]), x,
       pch = 16, col = "darkblue",
       xlab = "Theoretical Quantiles",
       ylab = "Sample Quantiles")

## Pour ajouter le graphique de l'exponentielle au graphique
## existant, on doit utiliser la fonction 'points' et renverser
## l'ordre des arguments.
points(qexp(y, fit.e), x, pch = 16, col = "darkred")

## Enfin, ajout de la droite y = x.
abline(0, 1)

## L'ajustement de la log-normale est bien meilleur, comme en
## fait foi la comparaison des densités avec l'histogramme.
hist(x, breaks = c(10, 12, 18, 25, 30))
curve(dlnorm(x, fit.ln[1], fit.ln[2]), add = TRUE,
      lwd = 2, col = "darkblue")
curve(dexp(x, fit.e), add = TRUE,
      lwd = 2, col = "darkred")
