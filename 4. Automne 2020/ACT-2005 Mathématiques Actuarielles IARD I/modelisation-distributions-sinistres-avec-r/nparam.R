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
### FONCTIONS DE RÉPARTITION ET DE PROBABILITÉ EMPIRIQUES
###

## DONNÉES INDIVIDUELLES

## On va travailler avec les données "dental" fournies dans la
## première édition de Loss Models. Il s'agit de 10 montants de
## réclamation en assurance dentaire avec une franchise de 50.
## Ces données sont distribuées avec actuar.
data(dental, package = "actuar") # charger les données
dental                           # les données

## Fonction de répartition empirique. La fonction 'ecdf' de R
## retourne une fonction pour calculer la fonction de répartition
## empirique en un point quelconque. Les fonctions génériques
## 'summary', 'knots' et 'plot' comportent des méthodes pour les
## objets de classe "ecdf". La rubrique d'aide de 'ecdf' contient
## plusieurs exemples.
(Fn <- ecdf(dental))          # définition de la f.r. empirique
summary(Fn)                   # sommaire (peu utile)
knots(Fn)                     # les noeuds de la fonction
Fn(knots(Fn))                 # évaluation aux noeuds
Fn(c(20, 150, 1000))          # évaluation en d'autres points

## Graphiques de la fonction de répartition empirique, du plus
## simple à des plus élaborés.
plot(Fn)
plot(Fn, verticals = TRUE)
plot(Fn, verticals = TRUE, do.points = FALSE)

plot(Fn, verticals = TRUE,
     col.h = "blue", col.p = "red", col.v = "bisque",
     pch = 20)
abline(v = knots(Fn), lty = 2, col = "gray90")
abline(h = Fn(knots(Fn)), lty = 2, col = "gray90")

plot(Fn, col.h = "blue", col.p = "red", pch = 18)
segments(knots(Fn), 0, knots(Fn), Fn(knots(Fn)), col = "gray90")

## Fonction de probabilité empirique: utiliser la fonction
## 'table' pour déterminer la fréquence de chaque valeur dans
## l'échantillon.
table(dental)
(fn <- table(dental)/length(dental))
plot(dental, fn, type = "h")

## On peut aussi calculer et tracer un histogramme pour des
## données individuelles avec la fonction 'hist'. Spécifier
## l'option 'prob = TRUE' pour graduer l'axe des ordonnées en
## probabilités plutôt qu'en fréquences. Les classes sont
## déterminées automatiquement, mais peuvent être changées avec
## l'option 'breaks'.
hist(dental)                       # histogramme par défaut
hist(dental, plot = FALSE)$counts  # fréquence par classe
hist(dental, plot = FALSE)$density # fréq. relative par classe
hist(dental,
     breaks = c(0, 25, 100, 500, 1000, 2000)) # autres classes

## DONNÉES GROUPÉES

## On va utiliser les données "grouped dental" de Loss Models qui
## sont distribuées avec actuar.
library(actuar)               # charger le package
data(gdental)                 # charger les données
gdental                       # les données

## La fonction 'ogive' de actuar est l'analogue de 'ecdf' pour
## les données groupées.
(Gn <- ogive(gdental))        # définition
summary(Gn)                   # sommaire
knots(Gn)                     # les bornes
Gn(knots(Gn))                 # évaluation aux bornes
Gn(c(20, 150, 1000))          # évaluation en d'autres points
plot(Gn)                      # graphique

## Pour l'histogramme de données groupées, le package définit une
## méthode de 'hist' pour les objets de classe 'grouped.data'.
hist(gdental)                 # aussi simple que cela

###
### ESTIMATEURS DE LA FONCTION DE SURVIE
###

## ESTIMATEUR DE KAPLAN-MEIER

## On peut calculer l'estimateur de Kaplan-Meier dans R avec les
## fonctions 'Surv' et 'survfit' du package d'analyse de survie
## survival. Celui-ci est distribué avec R.
library(survival)

## La principale fonction d'estimation de la fonction de survie
## est 'survfit'. Celle-ci requiert des données sous forme
## d'objet de type 'Surv', créé avec la fonction du même nom.
##
## Pour nos besoins, il suffit de connaître les trois premiers
## arguments de 'Surv'. Il s'agit, dans l'ordre, de:
##
##   time: vecteur des points de troncature d_j (j = 1, ..., n)
##         si les données sont tronquées et censurées, ou valeur
##         de l'argument 'time2' si les données ne sont que
##         censurées;
##   time2: vecteur des observations x_j et des données
##          censurées u_j (j = 1, ..., n);
##   event: vecteur indiquant si la donnée j (j = 1, ..., n) est
##          une observation x_j (1, "décès") ou une donnée
##          censurée u_i (0, "vivant").
##
## On définit un objet contenant les données D2 de Loss Models.
d <- c(rep(0, 30), 0.3, 0.7, 1.0, 1.8, 2.1,
                   2.9, 2.9, 3.2, 3.4, 3.9)
x <- c(0.1, 0.5, 0.8, 0.8, 1.8, 1.8, 2.1, 2.5, 2.8, 2.9, 2.9,
       3.9, 4.0, 4.0, 4.1, 4.8, 4.8, 4.8, rep(5.0, 12), 5.0, 5.0,
       4.1, 3.1, 3.9, 5.0, 4.8, 4.0, 5.0, 5.0)
e <- rep(0, 40); e[c(4, 10, 11, 13, 16, 33, 34, 38)] <- 1
Surv(d, x, e)                 # objet contenant les données

## La fonction d'estimation de la fonction de survie est
## 'survfit'. Le premier argument de la fonction est une formule
## dont le côté gauche est un objet de classe 'Surv' contenant
## les données et créé avec la fonction du même nom. Dans notre
## contexte, le côté droit de la formule est simplement 1. Par
## défaut, la fonction ajuste les données avec l'estimateur de
## Kaplan-Meier.
(fit <- survfit(Surv(d, x, e) ~ 1)) # ajustement du modèle
(sfit <- summary(fit))              # fonction de survie estimée
plot(fit)                           # graphique de S_n(t)

## L'objet 'sfit' défini ci-dessus est une liste comportant,
## entre autres, les éléments suivants:
##
##   surv: valeurs de S_n(y_j), j = 1, ..., k;
##   time: valeurs de y_j;
##   n.risk: valeurs de r_j;
##   n.event: valeurs de s_j;
##   std.err: approximations de Greenwood de Var[S_n(y_j)].
##
## Comparons les valeurs de l'élément 'std.err' avec le calcul
## fait à partir de la formule présentée à la section 3.2.3.
## [Remarque: la fonction 'with' ci-dessous permet de faire des
## calculs "à l'intérieur" d'une liste ou d'un data frame,
## c'est-à-dire en utilisant directement les noms des éléments de
## la liste. Ainsi, si une liste 'x' contient les éléments 'a' et
## 'b', 'with(x, a + b)' est équivalent à 'x$a + x$b'.]
sfit$std.err^2                # valeurs obtenues avec 'survfit'
with(sfit,                    # calcul manuel
     surv^2 * cumsum(n.event/(n.risk * (n.risk - n.event))))

## Il est laissé en exercice de reproduire les résultats de
## l'exemple 3.4 avec 'survfit'.

## ESTIMATEUR DE NELSON-AALEN

## On peut aussi calculer l'estimateur de Nelson-Aalen dans R
## avec les fonctions 'Surv' et 'survfit' du package survival.
library(survival)             # chargé précédemment

## Nous supposons que les données sont complètes. Il suffit dans
## ce cas de passer le vecteur des observations à 'Surv'.
x <- c(0.8, 2.9, 2.9, 3.1, 4.0, 4.0, 4.1, 4.8) # données brutes
Surv(x)                                        # données "de survie"

## On calcule ensuite l'estimateur de la fonction de survie par
## la méthode de Nelson-Aalen avec la fonction 'survfit'. Pour ce
## faire, il faut spécifier le type d'estimation
## "fleming-harrington".
fit <- survfit(Surv(x) ~ 1, type = "fl") # ajustement du modèle
summary(fit)                  # fonction de survie estimée
plot(fit)                     # graphique de S(x) estimée
plot(fit, fun = "cumhaz")     # graphique de H(x) estimée


###
### ESTIMATION PAR NOYAUX
###

## On va comparer l'histogramme et divers estimateurs par noyaux
## du jeu de données suivant.
x <- c(10, 25, 40, 50, 100, 205, 208, 250, 768, 1045, 1067,
       1104, 1590, 1780, 1967, 1987, 2000, 2000, 2560, 2789,
       5067, 5896, 5890, 6980, 7000)

## Histogramme. On le sauvegarde dans un objet 'h' pour pouvoir
## le réutiliser plusieurs fois.
h <- hist(x, breaks = c(0, 500, 1500, 2500, 3000, 6000, 7000))

## La fonction 'density' de R calcule l'estimateur par noyaux
## d'un jeu de données. La fonction supporte tous les noyaux
## présentés dans la section 3.3 sauf le noyau gamma, ainsi que
## quelques autres. Outre un vecteur de données, la fonction a
## deux arguments principaux:
##
##    bw: la largeur de bande;
##    kernel: le type de noyau à utiliser ("gaussian",
##            "epanechnikov", "rectangular", "triangular", ...).
##
## La paramétrisation des noyaux dans R est légèrement différente
## de celle des notes: l'écart type du noyau est toujours égal à
## la largeur de bande. L'argument 'bw' ne correspond donc pas
## tout à fait à notre paramètre b, sauf dans le cas du noyau
## gaussien. La largeur de bande par défaut est calculée par la
## fonction 'bw.nrd0'.
bw.nrd0(x)                    # largeur de bande par défaut
R <- diff(quantile(x, c(0.25, 0.75)))   # espace interquartile
0.9 * min(sd(x), R/1.34)/length(x)^0.2  # vérification
(fg <- density(x, kernel = "gaussian")) # noyau gaussien
plot(fg)                                # graphique

## Séparation du périphérique graphique en quatre parties (deux
## lignes et deux colonnes) pour accueillir autant de graphiques.
## La fonction 'par' sert à régler les multiples paramètres
## graphiques. La fonction retourne les paramètres précédents,
## que l'on sauvegarde pour les rétablir plus tard.
op <- par(mfrow = c(2, 2))

## Comparaison de plusieurs noyaux avec la largeur de bande par
## défaut.
plot(h)
lines(density(x, kernel = "r"), col = "red") # uniforme
plot(h)
lines(density(x, kernel = "t"), col = "red") # triangulaire
plot(h)
lines(density(x, kernel = "e"), col = "red") # Epanechnikov
plot(h)
lines(density(x, kernel = "g"), col = "red") # gaussien

## Plus que le type de noyau, c'est surtout la largeur de bande
## qui a un impact sur l'estimateur. Plus la bande est large et
## plus l'estimateur est lisse puisque les noyaux se chevauchent
## davantage.
plot(density(x, kernel = "r", adjust = 0.25)) # 25 % du défaut
plot(density(x, kernel = "r", adjust = 0.50)) # 50 % du défaut
plot(density(x, kernel = "r", adjust = 1.25)) # 125 % du défaut
plot(density(x, kernel = "r", adjust = 1.50)) # 150 % du défaut

## Même exercice, mais avec le noyau d'Epanechnikov.
plot(density(x, kernel = "e", adjust = 0.25)) # 25 % du défaut
plot(density(x, kernel = "e", adjust = 0.50)) # 50 % du défaut
plot(density(x, kernel = "e", adjust = 1.25)) # 125 % du défaut
plot(density(x, kernel = "e", adjust = 1.50)) # 150 % du défaut

## Rétablir les anciens paramètres graphiques.
par(op)

###
### STATISTIQUES DESCRIPTIVES EMPIRIQUES
###

## On va illustrer avec les données 'dental' et 'gdental' les
## différentes fonctions disponibles dans R et dans actuar pour
## calculer les statistiques descriptives empiriques.
library(actuar)
data(dental)
data(gdental)

## SOMMAIRE DE DONNÉES INDIVIDUELLES

## La fonction 'summary' fournit rapidement et simplement les
## minimum, maximum, médiane, 2e et 3e quartiles ainsi que la
## moyenne de données individuelles.
summary(dental)

## MOMENTS

## On a des fonctions pour accéder aux moments empiriques les
## plus usuels.
mean(dental)                    # moyenne
var(dental)                     # variance (sans biais)
sd(dental)                      # écart type

## actuar fournit également une méthode de 'mean' pour les
## données groupées.
mean(gdental)

## Plus généralement, la fonction 'emm' de actuar permet de
## calculer n'importe quel moment (non centré) et ce, pour des
## données individuelles ou groupées.
(mu <- emm(dental))              # moyenne
emm(dental, 2) - emm(dental)^2   # variance (biaisée)
emm(dental - mu, 3)/sd(dental)^3 # asymétrie
emm(gdental, 2) - emm(gdental)^2 # variance données groupées

## ESPÉRANCE LIMITÉE

## actuar fournit la fonction 'elev' pour calculer la fonction
## d'espérance limitée empirique en n'importe quelle limite
## (données individuelles et groupées). Le fonctionnement est
## similaire à 'ecdf' et 'ogive'.
(lev <- elev(dental))         # définition
lev(knots(lev))               # calcul en chacun des points
lev(1200)                     # calcul en un point quelconque
mean(pmin(dental, 1200))      # vérification
plot(lev)                     # graphique

## Pour illustrer avec des données groupées, on vérifie le
## résultat de l'exemple 3.10.
x <- grouped.data(cj = c(0, 100, 200, 500), nj = c(5, 10, 2))
elev(x)(120)                  # = 1670/17

## QUANTILES

## La fonction 'quantile' de R calcule les quantiles empiriques
## pour des données individuelles selon l'un de sept (!)
## algorithmes différents. Sans autre argument, la fonction
## retourne les quartiles de l'échantillon selon l'algorithme 7
## présenté dans les remarques de la section 3.4.4. L'algorithme
## de Loss Models est le numéro 6.
quantile(dental)                # utilisation simple
quantile(dental, c(0.45, 0.80)) # autres quantiles
y <- sort(dental)               # statistiques d'ordre
0.3 * y[3] + 0.7 * y[4]         # algorithme de R
quantile(dental, 0.30)          # vérification
0.7 * y[3] + 0.3 * y[4]         # notre algorithme
quantile(dental, 0.3, type = 6) # numéro 6

## Pour des données groupées, la méthode de 'quantile' définie
## par actuar retourne simplement l'inverse de l'ogive.
quantile(gdental)                 # utilisation simple
quantile(gdental, c(0.45, 0.80))  # autres quantiles
ogive(gdental)(quantile(gdental)) # inverse de l'ogive
