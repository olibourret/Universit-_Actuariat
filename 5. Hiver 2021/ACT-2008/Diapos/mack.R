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

###
### Jeu de données du chapitre
###

## Nous illustrons d'abord la méthode de Mack avec le petit
## jeu de données usuel.
x <- as.triangle(matrix(c(100, 150, 175, 180, 200,
                          110, 168, 192, 205,  NA,
                          115, 169, 202,  NA,  NA,
                          125, 185,  NA,  NA,  NA,
                          150,  NA,  NA,  NA,  NA),
                        nrow = 5, byrow = TRUE))

## Calcul des estimateurs Chain-Ladder des facteurs de
## développement.
J <- ncol(x)             # nombre de périodes de développement
f <- sapply(seq.int(J - 1),
            function(x, j)
            {
                Cij   <- head(x[, j], J - j)
                Cij1p <- head(x[, j + 1], J - j)
                sum(Cij1p)/sum(Cij)
            },
            x = x)

## Facteurs de développement jusqu'à l'ultime.
f.ult <- rev(cumprod(c(1, rev(f))))

## Estimateurs des paramètres de variance.
s2 <- sapply(seq.int(J - 1),
             function(x, f, j)
             {
                 Cij   <- head(x[, j], J - j)
                 Cij1p <- head(x[, j + 1], J - j)
                 sum(Cij * (Cij1p/Cij - f[j])^2)/(J - j - 1)
             },
             x = x, f = f)

## Remplacement du dernier estimateur de variance qui est NaN.
s2[J - 1] <- min(s2[J - 2]^2/s2[J - 3], s2[J - 3], s2[J - 2])

## Calcul de toutes les projections à l'ultime ou, autrement
## dit, de la dernière colonne du triangle de développement.
CL.ult <- x[J * ((J - 1):0) + 1:J] * rev(f.ult)

## Estimateurs des erreurs quadratiques moyennes de prévision.
## Il est peut-être possible de tout vectoriser ces calculs,
## mais nous allons nous contenter d'y aller itérativement
## pour chacune des années d'accident (sauf la première). Le
## code sera plus simple ainsi.
MSEP <- numeric(J)         # initialisation d'un contenant
MSEP[1] <- NaN             # aucune valeur pour année 1
ratio <- s2/f^2            # sert souvent
for (i in 2:J)
{
    MSEP[i] <-
        CL.ult[i]^2 *
        sum(tail(ratio, i - 1) *
            (1/(x[i, J - i + 1] * cumprod(c(1, f[seq(J - i + 1, length.out = i - 2)]))) +
             1/sapply((J - i + 1):(J - 1),
                      function(x, j) sum(head(x[, j], J - j)),
                      x = x)))
}
MSEP
sqrt(MSEP)

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions normales.
provisions <- CL.ult - x[J * ((J - 1):0) + 1:J]
cbind("borne inf." = provisions - 1.645 * sqrt(MSEP),
      "provision" = provisions,
      "borne sup." = provisions + 1.645 * sqrt(MSEP))

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions log-normales.
provisions <- CL.ult - x[J * ((J - 1):0) + 1:J]
sigma2 <- log(1 + MSEP/provisions^2)
mu <- log(provisions) - sigma2/2
cbind("borne inf." = exp(mu - 1.645 * sqrt(sigma2)),
      "provision" = provisions,
      "borne sup." = exp(mu + 1.645 * sqrt(sigma2)))

## Coefficient de variation de chaque provision.
round(100 * sqrt(MSEP)/provisions)

## Estimateur de l'erreur quadratique moyenne de prévision
## totale. Encore ici, nous utilisons une boucle pour
## simplifier le code.
MSEP.tot <- 0              # initialisation
for (i in 2:J)
    MSEP.tot <- MSEP.tot + MSEP[i] +
        CL.ult[i] * sum(tail(CL.ult, -i)) *
        sum(2 * tail(ratio, i - 1)/
            sapply((J - i + 1):(J - 1),
                   function(x, j) sum(head(x[, j], J - j)),
                   x = x))
MSEP.tot
sqrt(MSEP.tot)

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions normales.
provision.tot <- sum(provisions)
cbind("borne inf." = provision.tot - 1.645 * sqrt(MSEP.tot),
      "provision" = provision.tot,
      "borne sup." = provision.tot + 1.645 * sqrt(MSEP.tot))

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions log-normales.
sigma2 <- log(1 + MSEP.tot/provision.tot^2)
mu <- log(provision.tot) - sigma2/2
cbind("borne inf." = exp(mu - 1.645 * sqrt(sigma2)),
      "provision" = provision.tot,
      "borne sup." = exp(mu + 1.645 * sqrt(sigma2)))

## Coefficient de variation de la provision totale.
round(100 * sqrt(MSEP.tot)/provision.tot)

## La fonction 'MackChainLadder' du paquetage ChainLadder
## donne à quelques variantes près les mêmes résultats.
(mack <- MackChainLadder(x))

## Jolis graphiques des résultats.
plot(mack)


###
### Jeu de données de la CAS
###

## Seconde illustration de la méthode de Mack à partir d'un
## jeu de données de la CAS disponible sous forme de fichier
## Excel à l'url suivante:
##
## https://www.casact.org/education/spring/2006/handouts/Mack-Method-handout.xls
##
## Cet exemple permet de valider notre code.
##
## Les données du triangle de développement se trouvent dans
## le fichier 'mack-cas.csv' fourni avec le présent fichier de
## script.
##
## Importons ces données dans R avec la commande 'read.csv2'.
## L'option 'header = FALSE' est nécessaire pour éviter que R
## n'interprète la première ligne du fichier comme les titres
## des colonnes. Nous convertissons ensuite le data frame
## produit par 'read.csv2' en une matrice avant transformer
## celle-ci en triangle de développement.
x <- as.triangle(as.matrix(read.csv2("mack-cas.csv", header = FALSE)))
x                          # nos données

## Calcul des estimateurs Chain-Ladder des facteurs de
## développement.
J <- ncol(x)             # nombre de périodes de développement
f <- sapply(seq.int(J - 1),
            function(x, j)
            {
                Cij   <- head(x[, j], J - j)
                Cij1p <- head(x[, j + 1], J - j)
                sum(Cij1p)/sum(Cij)
            },
            x = x)
f                          # ligne 29 du fichier Excel

## Facteurs de développement à l'ultime.
f.ult <- rev(cumprod(c(1, rev(f))))
f.ult                      # ligne 30 du fichier Excel

## Estimateurs des paramètres de variance.
s2 <- sapply(seq.int(J - 1),
             function(x, f, j)
             {
                 Cij   <- head(x[, j], J - j)
                 Cij1p <- head(x[, j + 1], J - j)
                 sum(Cij * (Cij1p/Cij - f[j])^2)/(J - j - 1)
             },
             x = x, f = f)
s2                         # ligne 46 du fichier Excel

## Remplacement du dernier estimateur de variance qui est NaN.
s2[J - 1] <- min(s2[J - 2]^2/s2[J - 3], s2[J - 3], s2[J - 2])
s2                         # ligne 47 du fichier Excel

## Calcul de toutes les projections à l'ultime ou, autrement
## dit, de la dernière colonne du triangle de développement.
CL.ult <- x[J * ((J - 1):0) + 1:J] * rev(f.ult)
CL.ult                     # colonne P du fichier Excel

## Estimateurs des erreurs quadratiques moyennes de prévision.
## Il est peut-être possible de tout vectoriser ces calculs,
## mais nous allons nous contenter d'y aller itérativement
## pour chacune des années d'accident (sauf la première).
MSEP <- numeric(J)         # initialisation d'un contenant
MSEP[1] <- NaN             # aucune valeur pour année 1
ratio <- s2/f^2            # sert souvent
for (i in 2:J)
{
    MSEP[i] <-
        CL.ult[i]^2 *
        sum(tail(ratio, i - 1) *
            (1/(x[i, J - i + 1] * cumprod(c(1, f[seq(J - i + 1, length.out = i - 2)]))) +
             1/sapply((J - i + 1):(J - 1),
                      function(x, j) sum(head(x[, j], J - j)),
                      x = x)))
}
MSEP
sqrt(MSEP)                 # colonne V du fichier Excel

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions normales.
provisions <- CL.ult - x[J * ((J - 1):0) + 1:J]
cbind("borne inf." = provisions - 1.645 * sqrt(MSEP),
      "provision" = provisions,
      "borne sup." = provisions + 1.645 * sqrt(MSEP))

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions log-normales.
provisions <- CL.ult - x[J * ((J - 1):0) + 1:J]
sigma2 <- log(1 + MSEP/provisions^2)
mu <- log(provisions) - sigma2/2
cbind("borne inf." = exp(mu - 1.645 * sqrt(sigma2)),
      "provision" = provisions,
      "borne sup." = exp(mu + 1.645 * sqrt(sigma2)))

## Coefficient de variation de chaque provision.
round(100 * sqrt(MSEP)/provisions) # colonne W du fichier Excel

## Estimateur de l'erreur quadratique moyenne de prévision
## totale. Encore ici, nous utilisons une boucle pour
## simplifier le code.
MSEP.tot <- 0              # initialisation
for (i in 2:J)
    MSEP.tot <- MSEP.tot + MSEP[i] +
        CL.ult[i] * sum(tail(CL.ult, -i)) *
        sum(2 * tail(ratio, i - 1)/
            sapply((J - i + 1):(J - 1),
                   function(x, j) sum(head(x[, j], J - j)),
                   x = x))
MSEP.tot
sqrt(MSEP.tot)             # cellule V17 du fichier Excel

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions normales.
provision.tot <- sum(provisions)
cbind("borne inf." = provision.tot - 1.645 * sqrt(MSEP.tot),
      "provision" = provision.tot,
      "borne sup." = provision.tot + 1.645 * sqrt(MSEP.tot))

## Intervalles de confiance à 90 % pour les provisions basées
## sur une hypothèse de provisions log-normales.
sigma2 <- log(1 + MSEP.tot/provision.tot^2)
mu <- log(provision.tot) - sigma2/2
cbind("borne inf." = exp(mu - 1.645 * sqrt(sigma2)),
      "provision" = provision.tot,
      "borne sup." = exp(mu + 1.645 * sqrt(sigma2)))

## Coefficient de variation de la provision totale.
round(100 * sqrt(MSEP.tot)/provision.tot) # cellule W17

## Résultats similaires avec 'MackChainLadder' du paquetage
## ChainLadder.
(mack <- MackChainLadder(x))
plot(mack)
