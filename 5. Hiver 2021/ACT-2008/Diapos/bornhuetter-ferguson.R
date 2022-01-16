### Emacs: -*- coding: utf-8; fill-column: 62; comment-column: 27; -*-
##
## Copyright (C) 2020 Vincent Goulet
##
## Ce fichier fait partie du projet
## «Provisionnement en assurance IARD (diapositives)»
## https://projets.fsg.ulaval.ca/git/scm/vg/diapos-provisionnement-develop
##
## Cette création est mise à disposition selon le contrat
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## http://creativecommons.org/licenses/by-sa/4.0/

## Charger le paquetage ChainLadder dans la session de
## travail.
library(ChainLadder)

## Le paquetage ChainLadder n'offre aucun fonction
## particulière pour calculer les provisions par la méthode de
## Bornhuetter-Ferguson. Comme pour la méthode Chain-Ladder,
## nous devons procéder par programmation.
##
## Illustration avec l'exemple numérique du chapitre.
## Définissons trois objets: le triangle de développement; le
## vecteur des taux de sinistralité; le vecteur des primes
## acquises. Pour ces deux derniers, nous étiquettons les
## données afin de ne pas perdre le fil de quelle donnée
## correspond à quelle année d'accident (simplement numérotées
## de 1 à 5 dans cet exemple).
x <- triangle(c(100, 150, 175, 180, 200,
                110, 168, 192, 205,
                115, 169, 202,
                125, 185,
                150))
LR <- c("1" = 0.6, "2" = 0.65, "3" = 0.7, "4" = 0.75, "5" = 0.8)
PA <- c("1" = 330, "2" = 350, "3" = 365, "4" = 385, "5" = 400)

## Première étape: calcul des estimateurs Chain-Ladder des
## facteurs de développement.
J <- ncol(x)              # nombre de périodes de développement
(f <- sapply(seq.int(J - 1),
             function(x, j) sum(head(x[, j + 1], J - j))/sum(head(x[, j], J - j)),
             x = x))

## Deuxième étape: calcul des estimateurs des paramètres du
## modèle.
(beta <- 1/cumprod(c(1, rev(f))))
(mu <- LR * PA)

## Troisième étape: calcul des provisions par année d'accident
## et totale. Aux fins d'illustration, nous calculons
## également les estimateurs de Bornhuetter-Ferguson des
## montants de sinistres cumulatifs ultimes; en pratique ce
## n'est pas nécessaire.
(prov.BF <- (1 - beta) * mu)
(prov.BF.tot <- sum(prov.BF))
(ult.BF <- getLatestCumulative(x) + (1 - beta) * mu)

## Nous reproduisons ci-dessous les résultats du tableau 2.4
## de Wüthrich et Merz (2008, p. 24).
##
## Entrée des données. Dans l'exemple 2.11 du livre, les
## estimateurs de l'espérance des sinistres ultimes sont
## fournis et présentés comme des estimations d'experts.
wm2008 <-
    triangle(c(
        5946975, 9668212, 10563929, 10771690, 10978394, 11040518, 11106331, 11121181, 11132310, 11148124,
        6346756, 9593162, 10316383, 10468180, 10536004, 10572608, 10625360, 10636546, 10648192,
        6269090, 9245313, 10092366, 10355134, 10507837, 10573282, 10626827, 10635751,
        5863015, 8546239,  9268771,  9459424,  9592399,  9680740,  9724068,
        5778885, 8524114,  9178009,  9451404,  9681692,  9786916,
        6184793, 9013132,  9585897,  9830796,  9935753,
        5600184, 8493391,  9056505,  9282022,
        5288066, 7728169,  8256211,
        5290793, 7648729,
        5675568))
mu <- c(11653101, 11367306, 10962965, 10616762, 11044881,
        11480700, 11413572, 11126527, 10986548, 11618437)

## Facteurs de développement.
J <- ncol(wm2008)
(f <- sapply(seq.int(J - 1),
             function(x, j) sum(head(x[, j + 1], J - j))/sum(head(x[, j], J - j)),
             x = wm2008))

## Paramètres de développement.
(beta <- 1/cumprod(c(1, rev(f))))

## Provisions et estimateurs de Bornhuetter-Ferguson.
(prov.BF <- (1 - beta) * mu)
(prov.BF.tot <- sum(prov.BF))
(ult.BF <- getLatestCumulative(wm2008) + (1 - beta) * mu)
