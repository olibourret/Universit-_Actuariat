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

