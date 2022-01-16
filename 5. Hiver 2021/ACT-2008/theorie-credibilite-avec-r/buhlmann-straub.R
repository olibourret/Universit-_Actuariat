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

## Charger le package actuar dans la session de travail.
library(actuar)

## Les données de Hachemeister (1975) sont fournies avec le
## paquetage actuar sous forme d'une matrice de 5 lignes et de
## 25 colonnes. La première colonne contient un identifiant
## d'État, les colonnes 2-13 les montants de sinistres moyens
## et les colonnes 14-25, les nombres de sinistres.
hachemeister

## Dès lors qu'un jeu de données comporte des colonnes autres
## que l'identifiant du contrat et les données de sinistres,
## il faut avoir recours aux arguments suivants de 'cm'.
##
## ratios: expression indiquant les colonnes dans lesquelles
##  se trouvent les données de sinistres;
## weights: expression indiquant les colonnes dans lesquelles
##  se trouvent les poids associés aux données de sinistres.
##
## Ces deux arguments sont utilisés comme l'argument 'select'
## de la fonction 'subset'. Cela permet d'indicer de manière
## très intuitive les colonnes du jeu de données.
##
## Par exemple, l'expression ci-dessous permet d'extraire les
## ratios des cinq premières années des données de
## Hachemeister.
subset(hachemeister, select = ratio.1:ratio.5)

## Ajustement du modèle de Bühlmann aux données de
## Hachemeister (sans tenir compte des volumes).
fit.B <- cm(~state, hachemeister,
            ratios = ratio.1:ratio.12)
summary(fit.B)

## L'argument 'method' de 'cm' permet de choisir l'estimateur
## de la variance inter. Trois choix sont disponibles.
##
## "Buhlmann-Gisler": notre estimateur sans biais;
## "Ohlsson": équivalent à "Buhlmann-Gisler" dans le modèle de
##   Buhlmann-Straub;
## "iterative": pseudo-estimateur de Bichsel-Straub.
##
## La vignette "credibility" du paquetage contient tous les
## détails sur les méthodes d'estimation de la variance inter.
vignette("credibility")

## Ajustement du modèle de Bühlmann-Straub avec l'estimateur
## sans biais de la variance inter (la méthode par défaut,
## donc non spécifiée ici). Il faut spécifier des poids.
fit.BS1 <- cm(~state, hachemeister,
             ratios = ratio.1:ratio.12,
             weights = weight.1:weight.12)
summary(fit.BS1)

## Même chose, mais avec le pseudo-estimateur de la variance
## inter.
fit.BS2 <- cm(~state, hachemeister,
             ratios = ratio.1:ratio.12,
             weights = weight.1:weight.12,
             method = "iterative")
summary(fit.BS2)
