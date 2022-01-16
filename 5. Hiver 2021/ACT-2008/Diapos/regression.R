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

## Reprenons toujours le même petit jeu de données.
Triangle <- as.triangle(matrix(c(100, 150, 175, 180, 200,
                                 110, 168, 192, 205,  NA,
                                 115, 169, 202,  NA,  NA,
                                 125, 185,  NA,  NA,  NA,
                                 150,  NA,  NA,  NA,  NA),
                               nrow = 5, byrow = TRUE))

## Première étape: le calcul des estimateurs des facteurs de
## développement.
J <- ncol(Triangle)              # nombre de périodes de développement
(f <- sapply(seq.int(J - 1),
             function(x, j)
             {
                 Cij   <- head(x[, j], J - j)
                 Cij1p <- head(x[, j + 1], J - j)
                 sum(Cij1p)/sum(Cij)
             },
             x = Triangle))

## Estimateurs des paramètres de variance
(s2 <- sapply(seq.int(J - 1),
              function(x, f, j)
              {
                 Cij   <- head(x[, j], J - j)
                 Cij1p <- head(x[, j + 1], J - j)
                 sum(Cij * (Cij1p/Cij - f[j])^2)/(J - j - 1)
              },
              x = Triangle, f = f))

## Ajustement d'un modèle de régression par les moindres carrés
## pondérés sur chaque couple d'années de développement.
CL <- lapply(1:(J - 1),
             function(x, j)
                 lm(y ~ x + 0,
                    data = data.frame(x = x[, j], y = x[, j + 1]),
                    weights = 1/x),
             x = Triangle)
CL                                      # pas très utile

## La fonction 'chainladder' du paquetage ChainLadder fait pour
## l'essentiel le même travail.
chainladder(Triangle)

## Le vecteur des coefficients de chaque régression correspond aux
## facteurs de développement.
sapply(CL, coef)
f

## Le vecteur des variances de chaque régression correspond aux
## facteurs de développement.
sapply(CL, function(x) summary(x)$sigma^2)
s2
