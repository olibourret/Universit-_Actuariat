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
### DONNÉES INDIVIDUELLES ET GROUPÉES
###

## Le vecteur simple (ou atomique) créé avec la fonction 'c' est
## encore le meilleur mode de stockage des données individuelles:
x <- c(30, 70, 130, 200, 260, 310, 450, 500, 520, 700, 830, 1070)

## Pour illustrer la procédure d'importation de données
## individuelles avec 'scan', on crée un fichier de données à
## partir de l'objet 'x' ci-dessus, puis on lit ces données avec
## 'scan' et on les stocke dans un nouvel objet.
write(x, "donnees.dat", ncol = 1) # création du fichier
(y <- scan("donnees.dat"))    # importation dans y
unlink("donnees.dat")         # nettoyage: suppression du fichier

## Pour tronquer (par le bas) les données, il suffit de
## sélectionner les observations au-dessus d'un certain seuil.
## Pour censurer (par le haut), on remplace les données au-dessus
## d'un seuil par ce seuil. La manière la plus simple de procéder
## est à l'aide de la fonction 'pmin'.
x[x > 100]                    # troncature par le bas à 100
pmin(x, 700)                  # censure par le haut à 700
pmin(x[x > 100], 700)         # les deux modifications

## Le traitement informatique des données groupées nécessite une
## méthode de stockage standard puisqu'il existe plusieurs
## différentes manières de les représenter dans un ordinateur:
## utiliser une matrice ou une liste, apparier les valeurs de n_j
## avec les c_{j - 1} ou avec les c_j, omettre ou non la valeur
## de c_0, etc. Le package actuar fournit des outils pour
## stocker, manipuler et résumer les données groupées. Avec des
## fonctions d'extraction, de remplacement et de sommaire
## spécifiques, la manipulation des données groupées se révèle
## aussi simple que celle des données individuelles.
library(actuar)               # charger le package

## Création d'un objet contenant des données groupées. On fournit
## deux vecteurs: les bornes des classes et les fréquences dans
## chaque classe. Les classes sont supposées contiguës. Puisqu'il
## faut fournir la borne inférieure de la première classe, le
## premier vecteur compte un élément de plus que le second. Les
## étiquettes des colonnes ("Classe" et "Frequence", ci-dessous)
## sont arbitraires.
(x <- grouped.data(Classe = c(10, 12, 14, 18, 23),
                   Frequence = c(3:1, 1)))

## Exemples de manipulations possibles avec de tels objets.
xx <- x                         # copie de travail
xx[, 1]                         # bornes des classes
xx[, 2]                         # fréquences
xx[c(1, 2), 2] <- c(4, 1); xx   # changement de fréquences
xx[1, 1] <- c(9, 13); xx        # changement de bornes

###
### FONCTION 'coverage'
###

## La fonction provient du package actuar. Il faut le charger en
## mémoire si ce n'était pas fait précédemment.
library(actuar)

## La fonction 'coverage' retourne une fonction pour calculer la
## f.r. ou la f.d.p. de la variable aléatoire du montant payé par
## paiement ou payé par sinistre modifiée par une franchise
## (ordinaire ou à atteindre), une limite, de la coassurance ou
## l'inflation.
##
## On examine les quatre combinaisons possibles de variables
## aléatoires et de franchise. On suppose que la variable
## aléatoire X a une distribution gamma. Le montant de la
## franchise est d = 1.
##
## 1. Montant par paiement et franchise ordinaire (cas par
## défaut)
f <- coverage(dgamma, pgamma, deductible = 1) # objet
mode(f)                       # c'est une fonction
f                             # code de la fonction
f(0, 3)                       # calcul en x = 0
f(5, 3)                       # calcul en x = 5
dgamma(5 + 1, 3)/pgamma(1, 3, lower = FALSE) # idem
curve(dgamma(x, 3),
      from = 0, to = 10, ylim = c(0, 0.3))   # originale
curve(f(x, 3),
      from = 0.1, col = "blue", add = TRUE)  # modifiée

## 2. Montant par sinistre et franchise ordinaire
f <- coverage(dgamma, pgamma, deductible = 1, per.loss = TRUE)
f(0, 3)                       # masse à 0
pgamma(1, 3)                  # idem
curve(dgamma(x, 3),
      from = 0, to = 10, ylim = c(0, 0.3))   # originale
curve(f(x, 3),
      from = 0.1, col = "blue", add = TRUE)  # modifiée
points(0, f(0, 3), pch = 16, col = "blue")   # masse à 0

## 3. Montant par paiement et franchise à atteindre
f <- coverage(dgamma, pgamma, deductible = 1, franchise = TRUE)
f(0, 3)                                  # x = 0
f(0.5, 3)                                # 0 < x < 1
f(1, 3)                                  # x = 1
f(5, 3)                                  # x > 1
dgamma(5, 3)/pgamma(1, 3, lower = FALSE) # idem
curve(dgamma(x, 3),
      from = 0, to = 10, ylim = c(0, 0.3))        # originale
curve(f(x, 3),
      from = 1.1, col = "blue", add = TRUE)       # modifiée
curve(f(x, 3),
      from = 0, to = 1, col = "blue", add = TRUE) # 0 < x < 1

## 4. Montant par sinistre et franchise à atteindre
f <- coverage(dgamma, pgamma, deductible = 1,
              per.loss = TRUE, franchise = TRUE)
f(0, 3)                       # masse à 0
pgamma(1, 3)                  # idem
f(0.5, 3)                     # 0 < x < 1
f(1, 3)                       # x = 1
f(5, 3)                       # x > 1
curve(dgamma(x, 3),
      from = 0, to = 10, ylim = c(0, 0.3))          # originale
curve(f(x, 3),
      from = 1.1, col = "blue", add = TRUE)         # modifiée
points(0, f(0, 3), pch = 16, col = "blue")          # masse à 0
curve(f(x, 3),
      from = 0.1, to = 1, col = "blue", add = TRUE) # 0 < x < 1

## La vignette (fichier PDF) contient les formules générales pour
## toutes les modifications possibles.
vignette("coverage")
