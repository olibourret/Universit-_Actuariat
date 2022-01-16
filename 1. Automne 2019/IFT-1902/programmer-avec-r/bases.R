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

###
### DONNÉES ET PROCÉDURES FONDAMENTALES  
###

## NOMBRES ET OPÉRATEURS ARITHMÉTIQUES

## Tous les nombres réels sont stockés en double précision
## dans R, entiers comme fractionnaires. R permet aussi de
## définir des nombres en notation scientifique et des nombres
## complexes.
486                        # nombre réel entier
0.3324                     # nombre réel fractionnaire
2e-3                       # notation scientifique
1 + 2i                     # nombre complexe

## La définition des opérateurs arithmétiques standards coule
## de source.
137 + 349                  # addition
1000 - 334                 # soustraction
5 * 42                     # multiplication
10/4                       # division
2^3                        # puissance
-42                        # changement de signe

## Les opérateurs de comparaison (égalité et inégalité)
## retournent une valeur booléenne.
486 < 521                  # plus petit
486 >= 521                 # plus grand ou égal
486 != 521                 # différent de

## Attention à cette erreur commune --- et parfois difficile à
## détecter: '=' n'est PAS l'opérateur de comparaison de
## l'égalité entre deux valeurs.
5 = 2                      # erreur de syntaxe

## L'opérateur de comparaison est plutôt '=='.
486 == 486                 # comparaison
y = 486                    # pas un test...
y                          # ... plutôt une affectation

## Les opérateurs '==' et '!=' vérifient l'égalité (ou non)
## bit pour bit dans la représentation interne des nombres
## dans l'ordinateur. Ça fonctionne bien pour les entiers ou
## les valeurs booléennes, mais pas pour les nombres réels ou,
## plus insidieux, pour les nombres entiers provenant d'un
## calcul et qui ne sont entiers qu'en apparence.
##
## [Pour en savoir (un peu) plus:
##  https://floating-point-gui.de/formats/fp/]
1.2 + 1.4 + 2.8            # 5.4 en apparence
1.2 + 1.4 + 2.8 == 5.4     # non?!?
0.3/0.1 == 3               # à gauche: faux entier

## L'opérateur ':' est très utile pour générer des suites de
## nombres avec un pas fixe de 1 entre chaque nombre.
1:10                       # entiers de 1 à 10
5:-2                       # entiers de 5 à -2

## L'opérateur modulo retourne le reste d'une division.
544 %% 119                 # 544/119 = 4 reste 68
119 %% 544                 # x %% y = x si x < y

## La division entière est l'opération duale du modulo: elle
## retourne la partie entière d'une division.
544 %/% 119                # 544/119 = 4 reste 68
119 %/% 544                # x %/% y = 0 si x < y

## L'opérateur modulo est souvent utilisé pour déterminer si
## un nombre est pair ou impair. Un nombre 'x' est pair si 'x
## mod 2 = 0' et il est impair si 'x mod 2 = 1'.
554 %% 2                   # pair
119 %% 2                   # impair

## CHAINES DE CARACTÈRES

## On crée une chaine de caractères en l'entourant de
## guillemets doubles " ".
"a"                        # chaine de 1 caractère
"foobar"                   # chaine de 6 caractères
"486"                      # chaine de 3 caractères

## Les opérateurs de comparaison sont également définis pour
## les chaines de caractères en fonction de l'ordre
## lexicographique. Attention: c'est un terrain miné selon la
## langue utilisée; consultez la rubrique d'aide de
## 'Comparison' au besoin (qui vous dira de ne pas faire
## d'hypothèses sur l'ordre lexicographique entre deux chaines
## de caractères). Quelques exemples simples.
"a" < "d"                  # ordre alphabétique
"a" < "A"                  # minuscules avant majuscules
"1" < "a"                  # chiffres avant lettres

## VALEURS BOOLÉENNES

## 'TRUE' et 'FALSE' sont des noms réservés pour identifier
## les valeurs booléennes correspondantes.
TRUE                       # vrai
FALSE                      # faux
!TRUE                      # négation logique
TRUE & FALSE               # ET logique
TRUE | FALSE               # OU logique

## [Les expressions suivantes (qui anticipent sur la suite)
## construisent les tables de vérité du Et logique et du OU
## logique.]
p <- c(TRUE, TRUE, FALSE, FALSE)
q <- c(TRUE, FALSE, TRUE, FALSE)
cbind("p" = p, "q" = q, "p ET q" = p & q)
cbind("p" = p, "q" = q, "p OU q" = p | q)

## AUTRES DONNÉES FONDAMENTALES DE R

## Donnée manquante. 'NA' est un nom réservé pour représenter
## une donnée manquante.
NA                         # valeur admissible
NA + 2                     # tout calcul avec 'NA' donne NA

## Valeurs infinies et indéterminée. 'Inf', '-Inf' et 'NaN'
## sont des noms réservés.
1/0                        # +infini
-1/0                       # -infini
0/0                        # indétermination

## Valeur "néant". 'NULL' est un nom réservé pour représenter
## le néant, rien.
NULL                       # valeur admissible
NULL + 2                   # aucun calcul possible avec néant 

###
### COMMANDES R            
###

## Les expressions entrées à la ligne de commande sont
## immédiatement évaluées et le résultat est affiché à
## l'écran, comme avec une grosse calculatrice.
1                          # une constante
(2 + 3 * 5)/7              # priorité des opérations
3^5                        # puissance
exp(3)                     # fonction exponentielle
sin(pi/2) + cos(pi/2)      # fonctions trigonométriques
gamma(5)                   # fonction gamma

## Lorsqu'une expression est syntaxiquement incomplète,
## l'invite de commande change de '> ' à '+ '.
2 -                        # expression incomplète
5 *                        # toujours incomplète
3                          # complétée

## Entrer le nom d'un objet affiche son contenu. Pour une
## fonction, c'est son code source qui est affiché.
pi                         # constante numérique intégrée
letters                    # chaîne de caractères intégrée
LETTERS                    # version en majuscules
matrix                     # fonction interne

## On crée des nouveaux objets en leur affectant une valeur
## avec l'opérateur '<-'. *Ne pas* utiliser '=' pour
## l'affectation.
x <- 5                     # affectation de 5 à l'objet 'x'
5 -> x                     # idem, mais peu utilisé
x                          # voir le contenu
(x <- 5)                   # affectation et affichage
y <- x                     # affecter la valeur de 'x' à 'y'
x <- y <- 5                # idem, en une seule expression
y                          # 5
x <- 0                     # changer la valeur de 'x'...
y                          # ... ne change pas celle de 'y'

## Pour regrouper plusieurs expressions en une seule commande,
## il faut soit les séparer par un point-virgule ';', soit les
## regrouper à l'intérieur d'accolades { } et les séparer par
## des retours à la ligne.
x <- 5; y <- 2; x + y      # compact; éviter dans les scripts
x <- 5;                    # éviter les ';' superflus
{                          # début d'un groupe
    x <- 5                 # première expression du groupe
    y <- 2                 # seconde expression du groupe
    x + y                  # dernière expression du groupe
}                          # fin du groupe et résultat
{x <- 5; y <- 2; x + y}    # valide, mais redondant 

###
### VECTEURS               
###

## La fonction de base pour créer des vecteurs est 'c'. Il
## peut s'avérer utile de nommer les éléments d'un vecteur.
x <- c(A = -1, B = 2, C = 8, D = 10) # création d'un vecteur
names(x)                             # extraire les noms
names(x) <- letters[1:length(x)]     # changer les noms
x                                    # nouveau vecteur

## Attention aux chaines de caractères! Dans R, une chaine de
## caractères n'est pas un vecteur de caractères. Une chaine
## est un vecteur de longueur 1 comptant plusieurs caractères.
## Un vecteur peut contenir plusieurs chaines de caractères.
length("foobar")           # *une* chaine de 6 caractères
c("foo", "bar")            # *deux* chaines de 3 caractères
length(c("foo", "bar"))    # longueur de 2

## La fonction 'vector' sert à initialiser des vecteurs avec
## des valeurs prédéterminées. Elle compte deux arguments: le
## mode du vecteur et sa longueur. Les fonctions 'numeric',
## 'logical', 'complex' et 'character' constituent des
## raccourcis pour des appels à 'vector'.
vector("numeric", 5)       # vecteur initialisé avec des 0
numeric(5)                 # équivalent
numeric                    # en effet, voici la fonction
logical(5)                 # initialisé avec FALSE
complex(5)                 # initialisé avec 0 + 0i
character(5)               # initialisé avec chaînes vides

## Si l'on mélange dans un même vecteur des objets de mode
## différents, il y a conversion forcée vers le mode pour
## lequel il y a le moins de perte d'information, c'est-à-dire
## vers le mode qui permet le mieux de retrouver la valeur
## originale des éléments.
c(5, TRUE, FALSE)          # conversion en mode 'numeric'
c(5, "z")                  # conversion en mode 'character'
c(TRUE, "z")               # conversion en mode 'character'
c(5, TRUE, "z")            # conversion en mode 'character'

## Les fonctions 'as.numeric', 'as.logical' et 'as.character' sont
## utiles pour forcer la conversion d'un mode vers un autre.
as.logical(1)              # conversion en booléen
as.numeric(TRUE)           # conversion en numérique
as.character(1)            # conversion en chaine de caractères

### INDIÇAGE

## L'indiçage est une opération importante et beaucoup
## utilisée. Elle sert à extraire des éléments d'un vecteur
## avec la construction 'x[i]', ou à les remplacer avec la
## construction 'x[i] <- y'. Les fonctions sous-jacentes sont
## '[' et '[<-'.
##
## Les expressions suivantes illustrent les cinq méthodes
## d'indiçage.
x                          # le vecteur
x[1]                       # extraction par position
"["(x, 1)                  # idem avec la fonction '['
x[-2]                      # suppression par position
x[x > 5]                   # extraction par critère
x["c"]                     # extraction par nom
x[]                        # tous les éléments
x[numeric(0)]              # différent d'indice vide

## Laissons tomber les noms de l'objet.
names(x) <- NULL           # suppression de l'attribut 'names'

## Quelques cas spéciaux d'indiçage.
length(x)                  # rappel de la longueur
x[1:8]                     # vecteur allongé avec des NA
x[0]                       # extraction de rien
x[0] <- 1; x               # affectation de rien
x[c(0, 1, 2)]              # indice 0 ignoré
x[c(1, NA, 5)]             # indice NA retourne NA
x[2.6]                     # fractions tronquées vers 0

## ARITHMÉTIQUE VECTORIELLE

## L'unité de base de l'arithmétique en R est le vecteur. Cela
## rend très simple et intuitif de faire des opérations
## mathématiques courantes.
##
## Là où plusieurs langages de programmation exigent des
## boucles, R fait le calcul directement.
##
## En effet, les règles de l'arithmétique en R sont
## globalement les mêmes qu'en algèbre vectorielle et
## matricielle.
5 * c(2, 3, 8, 10)         # multiplication par une constante
c(2, 6, 8) + c(1, 4, 9)    # addition de deux vecteurs
c(0, 3, -1, 4)^2           # élévation à une puissance

## Dans les règles de l'algèbre vectorielle, les longueurs des
## vecteurs doivent toujours concorder.
##
## R permet plus de flexibilité en recyclant les vecteurs les
## plus courts dans une opération.
##
## Il n'y a donc à peu près jamais d'erreurs de longueur en R!
## C'est une arme à deux tranchants: le recyclage des vecteurs
## facilite le codage, mais peut aussi résulter en des
## réponses complètement erronées sans que le système ne
## détecte d'erreur.
8 + 1:10                   # 8 est recyclé 10 fois
c(2, 5) * 1:10             # c(2, 5) est recyclé 5 fois
c(-2, 3, -1, 4)^(1:4)      # quatre puissances différentes

## Dans les opérations arithmétiques (ou, plus généralement,
## les opérations conçues pour travailler avec des nombres),
## les valeurs booléennes TRUE et FALSE sont automatiquement
## converties en 1 et 0, respectivement. Conséquence: il est
## possible de faire des calculs avec des valeurs booléennes!
c(5, 3) + c(TRUE, FALSE)   # équivalent à c(5, 3) + c(1, 0)
5 + (3 < 4)                # (3 < 4) vaut TRUE
5 + 3 < 4                  # priorité des opérations!

## Dans les opérations logiques, ce sont les nombres qui sont
## convertis en valeurs booléennes. Dans ce cas, zéro est
## traité comme FALSE et tous les autres nombres comme TRUE.
0:5 & 5:0
0:5 | 5:0
!0:5

###
### FONCTIONS  
###

## PROGRAMMATION FONCTIONNELLE

## Les fonctions sont des objets comme les autres dans R. Cela
## signifie que:
##
## - le contenu d'une fonction (son code source) est toujours
##   accessible;
## - une fonction peut accepter en argument une autre
##   fonction;
## - une fonction peut retourner une fonction comme résultat;
## - l'utilisateur peut définir de nouvelles fonctions.
seq                        # contenu est le code source
mode(seq)                  # mode est "function"
rep(seq(5), 3)             # fonction argument d'une fonction
lapply(1:5, seq)           # idem
mode(ecdf(rpois(100, 1)))  # résultat de ecdf est une fonction
ecdf(rpois(100, 1))(5)     # évaluation en un point
c(seq, rep)                # vecteur de fonctions!

## DÉFINITION D'UNE FONCTION

## On définit une nouvelle fonction avec la syntaxe suivante:
##
##   <nom> <- function(<arguments>) <corps>
##
## où
##
## - 'nom' est le nom de la fonction;
## - 'arguments' est la liste des arguments, séparés par des
##    virgules;
## - 'corps' est le corps de la fonction, soit une expression
##   ou un groupe d'expressions réunies par des accolades { }.
##
## Une fonction retourne toujours la valeur de la *dernière*
## expression de celle-ci.
##
## Voici un exemple trivial.
square <- function(x) x * x
square(10)

## Supposons que l'on veut écrire une fonction pour calculer
##
##   f(x, y) = x (1 + xy)^2 + y (1 - y) + (1 + xy)(1 - y).
##
## Deux termes sont répétés dans cette expression. On a donc
##
##   a = 1 + xy
##   b = 1 - y
##
## et f(x, y) = x a^2 + yb + ab.
##
## Une manière élégante de procéder au calcul de f(x, y) qui
## adopte l'approche fonctionnelle fait appel à une fonction
## intermédiaire à l'intérieur de la première fonction. (Il y
## a ici des enjeux de «portée lexicale» sur lesquels nous
## reviendrons en détail dans un chapitre ultérieur.)
f <- function(x, y)
{
    g <- function(a, b)
        x * a^2 + y * b + a * b
    g(1 + x * y, 1 - y)
}
f(2, 3)

## FONCTION ANONYME

## Comme le nom du concept l'indique, une fonction anonyme est
## une fonction qui n'a pas de nom. C'est parfois utile pour
## des fonctions courtes utilisées dans une autre fonction.
##
## Reprenons l'exemple précédent en généralisant les
## expressions des termes 'a' et 'b'. La fonction 'f'
## pourrait maintenant prendre en arguments 'x', 'y' et des
## fonctions pour calculer 'a' et 'b'.
f <- function(x, y, fa, fb)
{
    g <- function(a, b)
        x * a^2 + y * b + a * b
    g(fa(x, y), fb(x, y))
}

## Plutôt que de définir deux fonctions pour les arguments
## 'fa' et 'fb', on passe directement des fonctions anonymes
## en argument.
f(2, 3,
  function(x, y) 1 + x * y,
  function(x, y) 1 - y)

## VALEUR PAR DÉFAUT D'UN ARGUMENT

## La fonction suivante calcule la distance entre deux points
## dans l'espace euclidien à 'n' dimensions, par défaut par
## rapport à l'origine.
##
## Remarquez comment nous spécifions une valeur par défaut,
## l'origine, pour l'argument 'y'.
##
## (Note: la fonction 'sum' effectue... la somme de tous les
## éléments d'un vecteur.)
dist <- function(x, y = 0) sum((x - y)^2)

## Quelques calculs de distances.
dist(c(1, 1))                # (1, 1) par rapport à l'origine
dist(c(1, 1, 1), c(3, 1, 2)) # entre (1, 1, 1) et (3, 1, 2)

## ARGUMENT '...'

## Nous illustrons l'utilisation de l'argument '...' de la
## manière suivante pour le moment. Nous utiliserons davantage
## cet argument avec les fonctions d'application.
##
## La fonction 'curve' prend en argument une expression
## mathématique et trace la fonction pour un intervalle donné.
curve(x^2, from = 0, to = 2)

## Nous souhaitons, pour une raison quelconque, que tous nos
## graphiques de ce type (et seulement de ce type) soient
## tracés en orange.
curve(x^2, from = 0, to = 2, col = "orange")

## Plutôt que de redéfinir entièrement la fonction 'curve'
## avec tous ses arguments (et il y en a plusieurs), nous
## pouvons écrire une petite fonction qui, grâce à l'argument
## '...', accepte tous les arguments de 'curve'.
ocurve <- function(...) curve(..., col = "orange")
ocurve(x^2, from = 0, to = 2)

## APPEL D'UNE FONCTION

## L'interpréteur R reconnait un appel de fonction au fait que
## le nom de l'objet est suivi de parenthèses ( ).
##
## Une fonction peut n'avoir aucun argument ou plusieurs. Il
## n'y a pas de limite pratique au nombre d'arguments.
##
## Les arguments d'une fonction peuvent être spécifiés selon
## l'ordre établi dans la définition de la fonction.
##
## Cependant, il est beaucoup plus prudent et *fortement
## recommandé* de spécifier les arguments par leur nom avec
## une construction de la forme 'nom = valeur', surtout après
## les deux ou trois premiers arguments.
##
## L'ordre des arguments est important; il est donc nécessaire
## de les nommer s'ils ne sont pas appelés dans l'ordre.
##
## Certains arguments ont une valeur par défaut qui sera
## utilisée si l'argument n'est pas spécifié dans l'appel de
## la fonction.
##
## Examinons la définition de la fonction 'matrix', qui sert à
## créer une matrice à partir d'un vecteur de valeurs.
args(matrix)

## La fonction compte cinq arguments et chacun a une valeur
## par défaut (ce n'est pas toujours le cas).
##
## Quel sera le résultat de l'appel ci-dessous?
matrix()

## Les invocations de la fonction 'matrix' ci-dessous sont
## toutes équivalentes.
##
## Portez attention si les arguments sont spécifiés par nom ou
## par position.
matrix(1:12, 3, 4)
matrix(1:12, ncol = 4, nrow = 3)
matrix(nrow = 3, ncol = 4, data = 1:12)
matrix(nrow = 3, ncol = 4, byrow = FALSE, 1:12)
matrix(nrow = 3, ncol = 4, 1:12, FALSE)

###
### EXPRESSIONS CONDITIONNELLES  
###

## Débutons par deux petits exemples qui démontrent un usage
## adéquat de 'if'.
x <- c(-1, 2, 3)
if (any(x < 0)) print("il y a des nombres négatifs")
if (all(x > 0)) print("tous les nombres sont positifs")

## Première erreur fréquente dans l'utilisation de 'if': la
## condition en argument n'est pas une valeur unique.
##
## Portez bien attention au message d'avertissement de R: le
## test a été effectué, mais uniquement avec la première
## valeur du vecteur booléen 'x < 0'. Comme, dans le présent
## exemple, la première valeur de 'x' est négative,
## l'expression 'print' est exécutée.
if (x < 0)  print("il y a des nombres négatifs")

## Seconde erreur fréquente: tester que vrai est vrai. (Ce
## n'est pas une «erreur» au sens propre puisque la syntaxe
## est valide, mais c'est un non-sens sémantique, une forme de
## pléonasme comme «monter en haut» ou «deux jumeaux».)
##
## Voici un exemple de construction avec un test inutile. Le
## résultat de 'any' est déjà TRUE ou FALSE, alors pas besoin
## de vérifier si TRUE == TRUE ou si FALSE == TRUE. Comparez
## avec la version sémantiquement correcte, ci-dessus.
if (any(x < 0) == TRUE) print("il y a des nombres négatifs")

## Voici trois mises en oeuvre de la fonction valeur absolue
## accompagnées de leur algorithme. Elles vont de la plus
## (inutilement) compliquée à la plus simple (sans
## aller jusqu'à utiliser la fonction interne 'abs').
##
## Attention: ces fonctions ne sont pas vectorielles.
## (Pourquoi?)
##
## Algorithme 1 (trois clauses)
##   abs(réel x)
##     Si (x > 0)
##       Retourner x
##     Sinon si (x = 0)
##       Retourner 0
##     Sinon
##       Retourner -x
##   Fin abs
abs <- function(x)
{
    if (x > 0)
        x
    else if (x == 0)
        0
    else
        -x
}
abs(5)
abs(0)
abs(-2)

## Algorithme 2 (deux clauses)
##   abs(réel x)
##     Si (x < 0)
##       Retourner -x
##     Sinon
##       Retourner x
##   Fin abs
abs <- function(x)
{
    if (x < 0)
        -x
    else
        x
}
abs(5)
abs(0)
abs(-2)

## Algorithme 3 (une seule clause; requiert 'return')
##   abs(réel x)
##     Si (x < 0)
##       Retourner -x
##     Retourner x
##   Fin abs
abs <- function(x)
{
    if (x < 0)
        return(-x)
    x
}
abs(5)
abs(0)
abs(-2)

## Détail intéressant sur la structure 'if ... else ...': il
## est possible de l'utiliser comme une fonction normale,
## c'est-à-dire d'affecter le résultat de la structure à une
## variable.
##
## D'abord, le style de programmation le plus usuel:
## l'affectation est effectuée à l'intérieur des clauses 'if'
## et 'else'.
f <- function(y)
{
    if (y < 0)
        x <- "rouge"
    else
        x <- "jaune"
    paste("la couleur est:", x)
}
f(-2)
f(3)

## Ensuite, la version où le résultat de 'if ... else ...' est
## directement affecté dans la variable. C'est plus compact et
## très lisible si la conséquence et l'alternative sont des
## expressions courtes.
f <- function(y)
{
    x <- if (y < 0) "rouge" else "jaune"
    paste("la couleur est:", x)
}
f(-2)
f(3)

## De l'inefficacité de 'ifelse'.
##
## Supposons que l'on veut une fonction *vectorielle* pour calculer
##
##   f(x) = x + 2, si x < 0
##        = x^2,   si x >= 0.
##
## On se tourne naturellement vers ifelse() pour ce genre de
## calcul. Voyons voir le temps de calcul.
x <- sample(-10:10, 1e6, replace = TRUE)
system.time(ifelse(x < 0, x + 2, x^2))

## Solution alternative n'ayant pas recours à ifelse(). C'est
## plus long à programmer, mais l'exécution est néanmoins plus
## rapide.
f <- function(x)
{
   y <- numeric(length(x)) # contenant
   w <- x < 0              # x < 0 ou non
   y[w] <- x[w] + 2        # calcul pour les x < 0
   w <- !w                 # x >= 0 ou non
   y[w] <- x[w]^2          # calcul pour les x >= 0
   y
}
system.time(f(x))

###
### QUELQUES FONCTIONS INTERNES UTILES  
###

## Pour les exemples qui suivent, on se donne un vecteur non
## ordonné.
x <- c(50, 30, 10, 20, 60, 30, 20, 40)

## FONCTIONS MATHÉMATIQUES ET TRIGONOMÉTRIQUES

## R contient des fonctions pour calculer la plupart des
## fonctions mathématiques et trigonométriques usuelles.
exp(c(1, 2, -1))           # exponentielle
log(exp(c(1, 2, -1)))      # logarithme naturel
log10(c(1, 10, 100))       # logarithme en base 10
log(c(1, 5, 25), base = 5) # logarithme en base quelconque
sqrt(x)                    # racine carrée
abs(x - mean(x))           # valeur absolue
gamma(1:5)                 # fonction gamma
factorial(0:4)             # factorielle
?gamma                     # toutes les fonctions apparentées
cos(seq(0, pi, by = pi/4)) # cosinus
sin(seq(0, pi, by = pi/4)) # sinus
tan(seq(0, pi, by = pi/4)) # tangente
?Trig                      # toutes les fonctions apparentées

## SUITES ET RÉPÉTITION

## La fonction 'seq' sert à générer des suites générales. Ses
## principaux arguments sont 'from', 'to' et 'by'.
seq(from = 1, to = 10)       # équivalent à 1:10
seq(10)                      # idem
seq(1, 10, by = 2)           # avec incrément autre que 1
seq(-10, 10, length.out = 5) # incrément automatique

## La fonction 'seq_len' génère une suite de longueur 'n' à
## partir de 1. C'est une version simplifiée et plus rapide de
## 'seq(..., length.out = n)'. De plus, elle est plus robuste
## lorsque l'argument est 0.
seq(10)                    # suite 1, 2, ..., 10
seq(1, length.out = 10)    # idem robuste
seq_len(10)                # équivalent et plus rapide
seq(0)                     # pas ce que l'on penserait!
seq(1, length.out = 0)     # plus prudent
seq_len(0)                 # plus simple

## La fonction 'seq_along' génère une suite de la longueur du
## vecteur en argument à partir de 1. C'est une version
## simplifiée et plus rapide de 'seq(..., along = x)' et de
## 'seq_len(length(x))'.
seq(1, along = x)            # suite de la longueur de x
seq_len(length(x))           # idem, mais deux fonctions
seq_along(x)                 # plus rapide, plus simple

## La fonction 'rep' permet de répéter des vecteurs de
## plusieurs manières différentes.
rep(1, 10)                  # utilisation de base
rep(x, 2)                   # répéter un vecteur
rep(x, each = 4)            # répéter chaque élément
rep(x, times = 2, each = 4) # combinaison des arguments
rep(x, length.out = 20)     # résultat de longueur déterminée
rep(x, times = 1:8)         # nombre de répétitions différent
                            # pour chaque élément de 'x'

## Pour les deux types de répétitions les plus usuels, il y a
## les fonctions 'rep.int' et 'rep_len' qui sont plus rapides
## que 'rep'.
rep.int(x, 2)              # seulement répétition 'times'
rep_len(x, 10)             # seulement répétition 'length.out'

## EXTRACTION DU DÉBUT ET DE LA FIN D'UN OBJET

## L'idée des fonctions 'head' et 'tail', c'est que l'on se
## positionne en tête ou en queue d'un objet pour effectuer
## des extractions ou des suppressions de composantes.
##
## Avec un argument positif, les fonctions extraient des
## composantes depuis la tête ou la queue de l'objet. Avec un
## argument négatif, elles suppriment des composantes à
## l'«autre bout» de l'objet.
head(x, 3)                 # trois premiers éléments
head(x, -2)                # tous sauf les deux derniers
tail(x, 3)                 # trois derniers éléments
tail(x, -2)                # tous sauf les deux premiers

## Les fonctions sont aussi valides sur les matrices et les
## data frames. Elles extraient ou suppriment alors des lignes
## entières.
m <- matrix(1:30, 5, 6)    # matrice 5 x 6
head(m, 3)                 # trois premières lignes
tail(m, -2)                # sans les deux premières lignes

## ARRONDI
(x <- c(-21.2, -pi, -1.5, -0.2, 0, 0.2, 1.7823, 315))
round(x)                   # arrondi à l'entier
round(x, 2)                # arrondi à la seconde décimale
round(x, -1)               # arrondi aux dizaines
ceiling(x)                 # plus petit entier supérieur
floor(x)                   # plus grand entier inférieur
trunc(x)                   # troncature des décimales

## TESTS LOGIQUES

## Les fonctions 'any' et 'all' prennent en argument un
## vecteur booléen et elles indiquent, respectivement, si au
## moins une ou si toutes les valeurs sont TRUE.
any(c(TRUE, FALSE, FALSE))  # au moins une valeur TRUE
any(c(FALSE, FALSE, FALSE)) # aucune valeur TRUE
all(c(TRUE, TRUE, TRUE))    # toutes les valeurs TRUE
all(c(TRUE, FALSE, TRUE))   # aucune valeur TRUE

## Les fonctions sont des compléments l'une de l'autre: si
## 'any(x)' est TRUE, alors 'all(!x)' est FALSE, et
## vice-versa.
any(c(TRUE, FALSE, FALSE))   # TRUE
all(!c(TRUE, FALSE, FALSE))  # complément: FALSE
any(c(FALSE, FALSE, FALSE))  # FALSE
all(!c(FALSE, FALSE, FALSE)) # complément: TRUE

## Les fonctions sont habituellement utilisées avec une
## expression logique en argument.
x                          # rappel
x > 50                     # valeurs > 50?
x <= 50                    # valeurs <= 50?
any(x > 50)                # y a-t-il des valeurs > 50?
all(x <= 50)               # complément
all(x > 50)                # toutes les valeurs > 50?
any(x <= 50)               # complément

## SOMMAIRES ET STATISTIQUES DESCRIPTIVES
sum(x)                     # somme des éléments
prod(x)                    # produit des éléments
diff(x)                    # x[2] - x[1], x[3] - x[2], etc.
mean(x)                    # moyenne des éléments
mean(x, trim = 0.125)      # moyenne sans minimum et maximum
var(x)                     # variance (sans biais)
sd(x)                      # écart type
max(x)                     # maximum
min(x)                     # minimum
range(x)                   # c(min(x), max(x))
diff(range(x))             # étendue de 'x'
median(x)                  # médiane (50e quantile) empirique
quantile(x)                # quantiles empiriques
quantile(x, 1:10/10)       # on peut spécifier les quantiles
summary(x)                 # plusieurs des résultats ci-dessus

## SOMMAIRES CUMULATIFS ET COMPARAISONS ÉLÉMENT PAR ÉLÉMENT
(x <- sample(1:20, 6))
(y <- sample(1:20, 6))
cumsum(x)                  # somme cumulative de 'x'
cumprod(y)                 # produit cumulatif de 'y'
rev(cumprod(rev(y)))       # produit cumulatif renversé
cummin(x)                  # minimum cumulatif
cummax(y)                  # maximum cumulatif
pmin(x, y)                 # minimum élément par élément
pmax(x, y)                 # maximum élément par élément 
