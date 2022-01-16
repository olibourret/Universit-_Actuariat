## Copyright (C) 2020 Vincent Goulet
##
## Ce fichier fait partie du projet
## "Méthodes numériques en actuariat avec R"
## https://gitlab.com/vigou3/methodes-numeriques-en-actuariat
##
## Cette création est mise à disposition sous licence
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## https://creativecommons.org/licenses/by-sa/4.0/

###
### VALEURS ET VECTEURS PROPRES  
###

## Nous allons illustrer le calcul des valeurs et vecteurs
## propres dans R avec une matrice utilisée dans les exemples
## du chapitre.
(A <- matrix(c(0, 1, 1, 0, 2, 0, -2, 1, 3), nrow = 3))

## La fonction 'eigen' calcule les valeurs propres et vecteurs
## propres d'une matrice.
(e <- eigen(A))

## Les vecteurs propres sont normalisés de sorte que leur
## norme (longueur) soit toujours égale à 1. Pour vérifier les
## résultats calculés algébriquement, comparer simplement les
## valeurs relatives des coordonnées des vecteurs.
e$values[c(1, 2)]          # deux premières valeurs propres...
e$vectors[, c(1, 2)]       # ... et vecteurs correspondants
e$vectors[, 2]             # équivalent à (1, 0, -1)
e$vectors[, 2] * sqrt(2)   # avec norme de 2 plutôt que 1

e$values[3]                # troisième valeur propre
e$vectors[, 3]             # vecteur équivalent à (-2, 1, 1)
e$vectors[, 3] * sqrt(6)   # avec norme de 6 plutôt que 1

## Si la matrice est symétrique, les vecteurs propres sont
## orthonormaux.
(A <- matrix(c(4, 2, 2, 2, 4, 2, 2, 2, 4), nrow = 3))
crossprod(eigen(A)$vectors) # matrice identité  

###
### ANALYSE EN COMPOSANTES PRINCIPALES  
###

## Installation du paquetage RSKC pour obtenir les données
## "Optical Recognition of Handwritten Digits". Exécuter une
## seule fois!
#install.packages("RSKC")

## Chargement du jeu de données 'optd' sans charger tout le
## paquetage dans la session de travail.
data(optd, package = "RSKC")

## Création du graphique des deux composantes principales.
optd.acp <- prcomp(optd, center = TRUE, scale. = FALSE)
optd.coord <- predict(optd.acp, newdata = optd)
plot(x = optd.coord[, 1], y = optd.coord[, 2], type = "n",
     xlab = expression(Y[1]), ylab = expression(Y[2]))
text(x = optd.coord[, 1], y = optd.coord[, 2],
     labels = rownames(optd), cex = 0.5,
     col = rainbow(10)[as.numeric(rownames(optd)) + 1])
rect(-8, -30, 10, -16, lty = 2, border = "gray")
