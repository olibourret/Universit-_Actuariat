### Sprint de codage 3 - Partie 2
##  Olivier Bourret, Félix Laflamme, William Perron et Simon Veilleux

library(actuar)


# Attribution des valeurs données. 
probs <- c(0.5614, 0.4386)
e <- matrix(1, nrow = 2, ncol = 1)
rates <- matrix(c(-8.64, 0.101, 1.997, -1.095), ncol = 2)
# Valeur de x dans la fonction de répartition.
x <- 1


# Soit l'équivalence des matrices suivante : M = Tx = PDP^(-1).

# Poser la matrice M comme étant le produit scalaire de T avec x.
M <- rates * x

# Trouver les vecteurs propres de la matrice M.
P <- eigen(M)$vectors

# Trouver l'inverse de la matrice P soit P^(-1).
invP <- solve(P)

# Trouver la diagonalisation de la matrice M.
D <- invP %*% M %*% P

# Calculer l'exponentielle de D (e^D) en conservant uniquement les éléments de
# la diagonale. Les exp(0) = 1 qui ne sont pas sur la diagonale sont ainsi remplacés par 0.
expD <- diag(diag(exp(D)))

# Réponse de la fonction de répartition F(x).
1 - probs %*% P %*% expD %*% invP %*% e

# Validation de la réponse avec la fonction pphytpe.
pphtype(x, probs, rates)

