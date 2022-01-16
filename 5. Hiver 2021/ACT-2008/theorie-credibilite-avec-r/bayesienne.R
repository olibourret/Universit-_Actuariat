## Copyright (C) 2020 Vincent Goulet
##
## Ce fichier fait partie du projet
## «Théorie de la crédibilité avec R»
## https://gitlab.com/vigou3/theorie-credibilite-avec-r
##
## Cette création est mise à disposition sous licence
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## https://creativecommons.org/licenses/by-sa/4.0/

## Chargement du paquetage actuar. La prise en charge des
## modèles bayésiens linéaires requiert une version du
## paquetage supérieure ou égale à 2.3.0.
if (packageVersion("actuar") >= "2.3.0")
    library(actuar)

## La fonction 'cm' de actuar constitue l'interface unifiée
## pour les calculs de crédibilité. La fonction ajuste un
## modèle de crédibilité de précision à des données et elle
## retourne un objet à partir duquel il est possible de
## réaliser différentes opérations, notamment le calcul de
## primes de crédibilité avec la fonction 'predict'.
##
## Dans son utilisation pour le calcul de primes bayésiennes
## linéaires, la fonction 'cm' accepte trois arguments
## principaux ainsi qu'un nombre variable d'autres arguments
## selon le modèle bayésien utilisé:
##
## formula: chaine de caractères "bayes";
## data: NULL, un vecteur simple de données, ou une matrice ou
##   un data frame de données (contrats sur les lignes,
##   périodes dans les colonnes);
## likelihood: nom (en minuscules) de la distribution de la
##   variable aléatoire S|Theta = theta;
## ...: valeurs des paramètres fixes des distributions des
##   variables aléatoires S|Theta = theta (s'il y en a) et
##   Theta.
##
## Pour spécifier les paramètres d'une distribution <loi>, il
## s'agit d'utiliser les noms des arguments de la fonction
## 'd<loi>' ('dgamma', 'dbeta', etc.)
##
## Lorsque l'argument 'data' est NULL (ou manquant), 'cm'
## ajuste le modèle à priori. L'ajustement du modèle à
## postériori requiert des données, soit pour un seul contrat
## (un vecteur), soit pour plusieurs contrats (matrice ou data
## frame).
##
## Après ce long préambule, allons-y de quelques exemples.

###
### Modèle Bernoulli/bêta
###

## Ajustement du modèle à priori
##
##   S|Theta = theta ~ Bernoulli(theta)
##   Theta ~ Bêta(2, 1).
fit <- cm("bayes", likelihood = "bernoulli",
          shape1 = 2, shape2 = 1)

## Modèle ajusté.
fit

## Prédiction: il n'y a qu'une seule prime à calculer et c'est
## la prime collective.
predict(fit)

## Simulons 10 périodes d'observations de ce modèle pour 5
## contrats différents.
a <- 2                     # paramètre shape1 de la bêta
b <- 1                     # paramètre shape2 de la bêta
n <- 10                    # nombre de périodes
(theta <- rbeta(5, a, b))  # niveaux de risque
(x <- matrix(rbinom(5 * n, 1, theta), 5, n)) # données

## Ajustement des modèles après 10 périodes.
fit <- cm("bayes", data = x, likelihood = "bernoulli",
          shape1 = 2, shape2 = 1)

## Sommaire contenant le modèle et les primes de crédibilité.
summary(fit)

## Vérifions les calculs de primes à partir des résultats de
## l'exemple 3.3.
(a + rowSums(x))/(a + b + n)

## Écarts quadratiques entre les primes bayésiennes et les
## vraies valeurs des primes de risque (qui sont connues,
## ici).
(predict(fit) - theta)^2

###
### Modèle Poisson/gamma
###

## Modèle de l'exemple 3.5, partie g):
##
##   S|Theta = theta ~ Poisson(theta)
##   Theta ~ Gamma(3, 3).
##
## Calculons la prime de crédibilité après les cinq premières
## années d'observations.
(fit <- cm("bayes", data = c(5, 3, 0, 1, 1),
           likelihood = "poisson", shape = 3, rate = 3))
predict(fit)

## Pour réaliser quelque chose de plus amusant, reproduisons
## le tableau 3.1 des primes bayésiennes pour les 10 premières
## années d'observations.
##
## Tout d'abord, les données.
x <- c(5, 3, 0, 1, 1, 2, 0, 2, 0, 2)
n <- seq(0, length(x))

## Ensuite, le calcul des primes. Nous devons ajuster un
## nouveau modèle après chaque période d'observations.
primes <- sapply(n,
                 function(x, n) predict(cm("bayes", head(x, n),
                                           likelihood = "poisson",
                                           shape = 3, rate = 3)),
                 x = x)

## Enfin, le tableau.
cbind(n = n,                       # nombre de périodes
      x = c(NA, x),                # observation de la période
      "sum(x)" = c(NA, cumsum(x)), # total des observations
      shape = 3 + cumsum(c(0, x)), # paramètre alpha révisé
      rate = 3 + n,                # paramètre lambda révisé
      "B[n + 1]" = primes)         # primes bayésiennes

###
### Modèle normale/normale
###

## Certains modèles demandent de spécifier un paramètre de la
## distribution de S|Theta = theta. Dans le cas
## normale/normale, le paramètre à spécifier, 'sd' porte le
## même nom que le paramètre de la distribution de Theta.
## Comme le précise la rubrique d'aide de 'cm', il faut dans
## ce cas utiliser 'sd.lik' pour le paramètre de la
## vraisemblance.
cm("bayes", data = c(5, 3, 0, 1, 1),
   likelihood = "normal", sd.lik = 2,
   mean = 2, sd = 1)
