### Équipe 30
# Olivier Bourret
# William Kokis
# Louis-David Labbé
# Sebastian Daniel Marcias-Valadez Cigarroa


###           Sprint de codage 1 (Question 2)



### 2. Création d'un vecteur de longueur aléatoire dont les valeurs sont entre 0 et 20

## a) Élimination des valeurs du vecteur inférieur à 5 et supérieur à 15
y <- x[x>5 & x<15]

##b) Trouver la moyenne du minimum entre les nombres du vecteur
##    ou 10.
mean(pmin(y,10))



##################################################

## Question 1 

# A  1/10

# Commentaires :

## Question 2 

# R  4/5
# S  5/5

# Commentaires : Beau travail! Par contre, il ne fallait pas exclure les valeurs 5 et 15.



### Solutions

## Question 1

# Polycalc(réel x, entier n, réels c1, c2, ..., cn + 1)
#   Si (n = 0)
#       Retourner c1
#   Retourner c1 + x * Polycalc(x, n - 1, c2, c3, ..., cn + 1)
# Fin Polycalc

# ou

# Calculer la valeur du polynôme Pn(x) = c_0 + c_1 * x + c_2 * x^2 + ... + c_n * x^n
# en une valeur réelle x pour des nombres réels c_0, c_1, ..., c_n donnés.

#1. Poser p <- c_n.
#2. Si n = 0, retourner la valeur de p.
#3. Poser p <- c_(n-1) + x * p, n <-  n - 1, puis retourner à l'étape 2.


# ou

# Calculer la valeur du polynôme Pn(x) = c_0 + c_1 * x + c_2 * x^2 + ... + c_n * x^n
# en une valeur réelle x pour des nombres réels c_0, c_1, ..., c_n donnés.

# 1. Poser a_n <- c_n
# 2. Pour i  = n - 1 , ... , 0, n > 0, calculer a_i <- c_i + a_(i + 1) * x
# 3. Retourner a_0

## Question 2

# a)

y <- x[x >= 5 & x <= 15]

# b)

mean(pmin(y, 10))

