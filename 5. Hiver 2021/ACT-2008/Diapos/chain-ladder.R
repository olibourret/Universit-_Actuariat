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

## Le paquetage ChainLadder fournit diverses méthodes
## statistiques pour calculer les provisions pour sinistres
## subis mais non déclarés en assurance IARD. Comme son nom ne
## l'indique pas, il va bien au-delà de la méthode
## Chain-Ladder.
##
## Pour obtenir un avant-goût des fonctionnalités du
## paquetage, exécuter la démonstration et consulter la
## documentation.
demo("ChainLadder")
vignette("ChainLadder")

## L'un des premiers souçis en provisionnement IARD, c'est la
## représentation des données sous forme de triangles de
## développement.
##
## ChainLadder fournit une nouvelle classe d'objets "triangle"
## qui permet de manipuler les données de manière plus
## intuitive que s'il s'agissait simplement d'une matrice ou
## d'un data frame.
##
## La fonction 'triangle' (crée par votre dévoué professeur:-)
## transforme un vecteur de n(n + 1)/2 paiements en un
## triangle de développement n x n.
##
## Nous illustrons les procédures avec l'exemple numérique du
## chapitre.
x <- triangle(c(100, 150, 175, 180, 200,
                110, 168, 192, 205,
                115, 169, 202,
                125, 185,
                150))
x                         # affichage de l'objet
plot(x)                   # développement par année d'accident
plot(x, lattice = TRUE)   # de manière plus élaborée

## Outre la création d'objets spécifiques pour les triangles
## de développement, le paquetage n'offre aucune fonction
## particulière pour le calcul des projections et des
## provisions par la méthode Chain-Ladder de base. C'est en
## fait très simple à faire par programmation.
##
## Première étape: le calcul des estimateurs des facteurs de
## développement.
J <- ncol(x)              # nombre de périodes de développement
(f <- sapply(seq.int(J - 1),
             function(x, j) sum(head(x[, j + 1], J - j))/sum(head(x[, j], J - j)),
             x = x))

## Deuxième étape: le calcul des projections. Nous procédons
## colonne par colonne, de la gauche du triangle de
## développement vers la droite.
x.proj <- x               # nouvel objet pour contenir les projections
for (j in seq.int(J - 1))
    x.proj[J:(J - j + 1), j + 1] <- x.proj[J:(J - j + 1), j] * f[j]
x.proj                    # résultats
x.proj[, J]               # estimateurs CL des sinistres ultimes

## Troisième étape: le calcul des provisions par année
## d'accident et totale.
##
## La fonction 'getLatestCumulative' permet d'extraire les
## éléments de la diagonale du triangle de développement.
(prov.CL <- x.proj[, J] - getLatestCumulative(x))
(prov.CL.tot <- sum(prov.CL))

## Nous reproduisons ci-dessous les résultats du tableau 2.3
## de Wüthrich et Merz (2008) à partir des données de leur
## tableau 2.2 (p. 20).
##
## Entrée des données.
wm2008.proj <- wm2008 <-
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
wm2008

## Facteurs de développement.
J <- ncol(wm2008)
(f <- sapply(seq.int(J - 1),
             function(x, j) sum(head(x[, j + 1], J - j))/sum(head(x[, j], J - j)),
             x = wm2008))

## Calcul des projections.
for (j in seq.int(J - 1))
    wm2008.proj[J:(J - j + 1), j + 1] <- wm2008.proj[J:(J - j + 1), j] * f[j]
wm2008.proj

## Privisions.
(prov.CL <- wm2008.proj[, J] - getLatestCumulative(wm2008)
(prov.CL.tot <- sum(prov.CL))
