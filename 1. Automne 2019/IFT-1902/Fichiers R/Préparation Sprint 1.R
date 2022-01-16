

### Écrire le vecteur
a <- round(runif(n = 1, min = 0, max = 100))
x <- round(runif(n = a,min = 0, max = 20)) 



      
x <- c(2,4,2,5,7,13,20,16,NA,12,14,NA,NA,18,NA)


## a) Nouveau vecteur sans les valeurs manquantes

y <- na.omit(x)


## b) Compter le nombre d'éléments dans le vecteur

sum (y>12)

## c) Calculer la moyenne du vecteur y

z <- y[c(y>12)]
moyenneecart <- mean(z_1)

Écart_moyen_de_12 <- mean(z-12)
### 2. Produit xy
## a) Construction de la fonction produit à l'aide des fonctions exp et log

product <- function(x,y){
  exp(log(x)+log(y))           ##Fonction product
}

product(2,3)
product(c(2,4),3)              ##Exemples de la fonction product pour confirmer son efficacité


## b) Écrire une expression pour calculer les valeurs de f(x), où x = 0,1,...,5

Résultat <- exp(log(6)+log(1:5)+log((1:5)+1))

