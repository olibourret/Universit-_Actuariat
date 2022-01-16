## Copyright (C) 2019 Vincent Goulet
##
## Ce fichier fait partie du projet
## «Programmer avec R»
## https://gitlab.com/vigou3/programmer-avec-r
##
## Cette création est mise à disposition sous licence
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## https://creativecommons.org/licenses/by-sa/4.0/

## Afin d'illustrer l'utilité de bien présenter et de
## commenter son code, nous allons prendre une fonction dans
## un état assez pitoyable et l'améliorer graduellement.
##
## Bien qu'il existe une fonction 'sqrt' dans R pour calculer
## la racine carrée d'un nombre, nous allons programmer notre
## propre version. Elle est basée sur la méthode des
## approximations successives de Newton dont l'algorithme est
## le suivant:
##
## ALGORITHME Calculer la racine carrée d'un nombre x,
## c'est-à-dire la valeur y tel que y >= 0 et y^2 = x.
##
## 1. Poser y égal à une valeur de départ quelconque.
## 2. Si |y^2 - x| < e, retourner la valeur y.
## 3. Poser y <- (y + x/y)/2 et retourner à l'étape 2.
##
## La valeur 'e' dans l'algorithme représente la précision de
## l'approximation. Dans notre mise en oeuvre ci-dessous, nous
## utiliserons e = 0.001. Quant à la valeur de départ de
## l'étape 1, nous utiliserons y = 1.
##
## Notre mise en oeuvre de l'algorithme est itérative. Elle
## repose sur l'idée de répéter l'étape 3 «tant que» la
## condition de l'étape 2 n'est pas remplie. Ceci se traduit
## en langage informatique en boucle 'while'. Nous n'avons pas
## encore formellement étudié cette structure de contrôle,
## mais vous devriez néanmoins pouvoir suivre l'exemple
## aisément.
##
## Dernière chose: notre fonction 'sqrt' fait appel à une
## seconde fonction interne pour effectuer le calcul de
## l'étape 3 de l'algorithme.

### PRÉSENTATION DU CODE

## La première version du code ne respecte pas les règles de
## base d'indentation et d'«aération» du code. Résultat: un
## fouillis difficile à consulter.
sqrt<-function(x)
{if(x<0)
stop("x doit être un nombre positif")
 improve<-function(guess,x)
 mean(c(guess,x/guess))
y<-1
while(!abs(y^2-x)>=0.001)y<-improve(y, x)
                   return(y)

## Réviser seulement l'indentation permet déjà d'y voir plus
## clair. Tous les bons éditeurs de texte pour programmeurs
## sont capables d'indenter le code pour vous, que ce soit à
## la volée ou de manière asynchrone.
##
## Vous pouvez arriver au résultat ci-dessous avec RStudio en
## sélectionnant le code ci-dessus et en exécutant l'option du
## menu Code|Reindent Lines.
##
## Dans Emacs, l'indentation se fait automatiquement au fur et
## à mesure que l'on entre du code ou, autrement, en appuyant
## sur la touche de tabulation.
sqrt<-function(x)
{if(x<0)
     stop("x doit être un nombre positif")
     improve<-function(guess,x)
         mean(c(guess,x/guess))
     y<-1
     while(!abs(y^2-x)>=0.001)y<-improve(y, x)
     return(y)

## La simple indentation du code nous permet déjà de découvrir
## un bogue dans le code: il manque une accolade fermante } à
## la fin de la fonction.
##
## Corrigeons déjà le code.
sqrt<-function(x)
{if(x<0)
     stop("x doit être un nombre positif")
     improve<-function(guess,x)
         mean(c(guess,x/guess))
     y<-1
     while(!abs(y^2-x)>=0.001)y<-improve(y, x)
     return(y)
}

## Les normes usuelles de présentation du code informatique
## exigent également de placer les accolades ouvrantes et
## fermantes seules sur leur ligne et d'aérer le code avec des
## espaces autour des opérateurs et des structures de
## contrôle, après les virgules, etc. Comme pour du texte
## normal, les espaces rendent le code plus facile à lire.
##
## Dans RStudio, vous pouvez parvenir à la présentation
## ci-dessous avec la commande du menu Code|Reformat Code.
sqrt <- function(x)
{
    if (x < 0)
        stop("x doit être un nombre positif")
    improve <- function(guess, x)
        mean(c(guess, x/guess))
    y <- 1
    while (!abs(y^2 - x) < 0.001)
        y <- improve(y, x)
    return(y)
}

## Je recommande d'ajouter des lignes blanches additionnelles
## dans le code afin de bien séparer les blocs logiques. Dans
## le cas présent, ces blocs sont:
##
## 1. le test de validité de l'argument;
## 2. la définition de la fonction interne 'improve';
## 3. l'affectation de la valeur de départ;
## 4. les approximations successives;
## 5. la valeur finale.
sqrt <- function(x)
{
    if (x < 0)
        stop("x doit être un nombre positif")

    improve <- function(guess, x)
        mean(c(guess, x/guess))

    y <- 1

    while (!abs(y^2 - x) < 0.001)
        y <- improve(y, x)

    return(y)
}

### STYLE

## Il y a quelque chose à redire sur le style de cette
## fonction? Pourtant, les noms d'objets sont raisonnables, le
## coeur de la fonction n'est pas inutilement placé dans une
## clause 'else' après le test de validité de l'argument 'x',
## le calcul de la nouvelle approximation est placé sous une
## couche d'abstraction dans une dans une fonction interne...
##
## Il reste tout de même deux choses à améliorer.
##
## Tout d'abord, l'expression logique dans la clause 'while'
## qui utilise une formulation «n'est pas plus petite que
## 0.001» est inutilement compliquée. De plus, elle repose sur
## la priorité des opérations: la négation logique a-t-elle
## bel et bien une priorité plus faible que l'inégalité? Il
## suffit de réécrire l'expression sous la forme «est plus
## grand ou égal à 0.001» et tout sera plus clair.
##
## Ensuite, il y a ce 'return' à la dernière ligne de la
## fonction. Ça, c'est un gros non en R.
##
## Améliorons le style.
sqrt <- function(x)
{
    if (x < 0)
        stop("x doit être un nombre positif")

    improve <- function(guess, x)
        mean(c(guess, x/guess))

    y <- 1

    while (abs(y^2 - x) >= 0.001)
        y <- improve(y, x)

    y
}

### COMMENTAIRES

## Dernier élément manquant dans notre code: les commentaires.
##
## Vous trouverez ci-dessous un modèle de documentation du
## code inspiré de la struture des rubriques d'aide de R.

###
### sqrt(x)
###
##  Calculer la racine carrée d'un nombre.
##
##  Argument
##
##  x: nombre réel positif.
##
##  Valeur
##
##  Nombre y tel que y^2 = x.
##
sqrt <- function(x)
{
    ## Vérification de la validité de 'x'.
    if (x < 0)
        stop("x doit être un nombre positif")

    ## Fonction pour calculer la prochaine approximation selon
    ## la méthode de Newton. Si 'y' est l'approximation
    ## actuelle de la racine carrée de 'x', alors la nouvelle
    ## approximation est '(y + x/y)/2'.
    improve <- function(guess, x)
        mean(c(guess, x/guess))

    ## Valeur de départ de la procédure itérative.
    y <- 1

    ## Approximations successives.
    while (abs(y^2 - x) >= 0.001)
        y <- improve(y, x)

    ## Retourner la valeur tel que y^2 - x < 0.001.
    y
}
