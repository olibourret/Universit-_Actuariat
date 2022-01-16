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

###
### APPROCHE PARAMÉTRIQUE  
###

## Charger le package actuar dans la session de travail.
library(actuar)

## Les primes bayésiennes linéaires et les primes de
## crédibilité de Bühlmann sont identiques dans l'approche
## paramétrique.
##
## Tel que mentionné dans le texte du chapitre, 'cm' effectue
## le calcul des premières à partir des formules des secondes.
## Comparez les résultats ci-dessous aux formules des
## combinaisons de distribution Poisson/gamma et
## exponentielle/gamma.
cm("bayes", likelihood = "poisson",
   shape = 3, rate = 2)
cm("bayes", likelihood = "exponential",
   shape = 3, rate = 2)

## Un coup d'oeil au code source de la fonction 'bayes' révèle
## le secret de fabrication. Comme cette fonction est interne
## au paquetage (autrement dit, vous ne pouvez l'appeler
## directement), vous devez pour y accéder ajouter le préfixe
## 'actuar:::' devant le nom de l'objet pour afficher son
## contenu.
actuar:::bayes

###
### APPROCHE NON PARAMÉTRIQUE  
###

## Nous illustrons ici comment utiliser la fonction 'cm' pour
## calculer des primes de crédibilité pour des modèles non
## paramétriques.
##
## L'interface de 'cm' pour ce type de modèle est fortement
## inspirée de 'lm', la fonction d'ajustement de modèles
## linéaires de R.
##
## La fonction suppose d'abord que les données se trouvent
## dans une matrice ou dans un data frame à raison d'une ligne
## par contrat. La matrice ou le data frame doit également
## comporter une colonne (nommée) pour identifier les contrats
## à l'aide d'une valeur numérique ou texte.
(x <- data.frame(contract = 1:3,
                 matrix(c(0, 3, 3,
                          1, 4, 3,
                          2, 2, 2,
                          1, 1, 1,
                          2, 4, 2,
                          0, 4, 1), nrow = 3)))

## Les arguments de 'cm' obligatoires pour l'ajustement du
## modèle de Bühlmann sont les suivants:
##
## formula: formule de la forme '~ termes' où, dans le modèle
##   de Bühlmann, 'termes' est simplement le nom de la colonne
##   des données contenant les identifiants des contrats;
## data: les données
##
## Si la matrice ou le data frame contient des données autres
## que celles servant à la modélisation, l'argument 'ratios'
## permet d'indiquer dans quelles colonnes se trouvent les
## données. Par défaut, la fonction considérera que toutes les
## colonnes (autres que celle présente dans la formule)
## contiennent des données.
(fit <- cm(~ contract, x))                 # appel simple
(fit <- cm(~ contract, x, ratios = X1:X6)) # équivalent ici

## Calcul des primes de crédibilité.
predict(fit)

## Résultats détaillés.
summary(fit)
