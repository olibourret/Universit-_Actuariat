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
### ESTIMATION PAR LA MÉTHODE DU MAXIMUM DE VRAISEMBLANCE
###

## EXEMPLE 5.9
##
## Estimation du maximum de vraisemblance pour les paramètre
## d'une distribution gamma avec 'optim'. Aux fins de
## l'évaluation numérique, on simule un échantillon aléatoire
## d'une loi gamma.
x <- rgamma(100, 5, 2)

## On minimise la fonction de log-vraisemblance négative
## directement avec la fonction 'optim'.
##
## Les principaux arguments de 'optim' sont:
##
##  par: un vecteur contenant les valeurs initiales des
##       paramètres;
##   fn: fonction à minimiser. Le premier argument de fn doit
##       être le vecteur des paramètres.
##
## On peut passer des valeurs à 'fn' (les données, par exemple)
## par le biais de l'argument '...' de 'optim'.
##
## Note: l'argument 'log = TRUE' de 'dgamma' permet de calculer
## plus précisément le logarithme de la densité.
f <- function(p, x) -sum(dgamma(x, p[1], p[2], log = TRUE))
optim(c(1, 1), f, x = x)

## EXEMPLE 5.10
##
## Estimation du maximum de vraisemblance pour les paramètre
## d'une distribution gamma avec 'fitdistr'. La fonction se
## trouve dans le package MASS.
library(MASS)

## La distribution gamma étant reconnue par 'fitdistr', il suffit
## d'en spécifier le nom en argument. La fonction préparera la
## fonction de log-vraisemblance et choisira des valeurs de
## départ appropriées.
fitdistr(x, "gamma")

## EXEMPLE 5.11
##
## On estime les paramètres d'une loi Pareto par la méthode du
## maximum de vraisemblance pour l'échantillon simulé ci-dessous
## avec la fonction 'rapreto' du package actuar.
library(actuar)               # charger le package
set.seed(2)                   # toujours le même échantillon
x <- rpareto(100, 5, 4000)

## Les estimateurs des moments de $\alpha$ et $\lambda$ seront
## utilisés comme valeurs de départ dans 'fitdistr'.
m <- emm(x, c(1, 2))          # deux premiers moments
(alpha.mme <- 2 * (m[2] - m[1]^2)/(m[2] - 2 * m[1]^2))
(lambda.mme <- (prod(m))/(m[2] - 2 * m[1]^2))

## Estimation avec 'fitdistr'. Pas de problème de convergence
## ici.
fitdistr(x, dpareto,
         start = list(shape = alpha.mme,
                      scale = lambda.mme))

## Lorsque la fonction d'optimisation s'égare dans les valeurs
## négatives des paramètres, on peut utiliser le truc suivant:
## plutôt que d'estimer les paramètres eux-mêmes, on estime leurs
## logarithmes. Ceux-ci demeurent alors valides sur tout l'axe
## des réels.
f <- function(x, lshape, lscale)
    dpareto(x, exp(lshape), exp(lscale))
(fit <- fitdistr(x, f,
                  start = list(lshape = log(alpha.mme),
                               lscale = log(lambda.mme))))

## Les valeurs obtenues ci-dessus sont les logarithmes des
## paramètres.
exp(unname(fit$estimate))

## Dans le cas présent, on peut réduire le problème de
## maximisation en deux dimensions à un problème de recherche de
## racine en une seule dimension. On définit d'abord la fonction
## dont on cherche la racine.
g <- function(b, x)
{
    n <- length(x)
    x <- x + b
    u <- b * sum(1/x)
    n * (n - u)/u + n * log(b) - sum(log(x))
}

## On trouve ensuite la racine avec la fonction 'uniroot' sur
## l'intervalle (0, max(x)).
(lambda <- uniroot(g, lower = 1E-10, upper = max(x), x = x)$root)
(alpha <- 1/(-1 + length(x)/(lambda * sum(1/(x + lambda)))))

## EXEMPLE 5.13
##
## On a des données de contrats d'assurance comportant une
## franchise de 75 et une limite de 800.
x <- c(280.48, 460.26, 60.41, 725.00, 340.34, 166.08, 485.60,
       199.15, 45.56, 118.11, 493.15, 239.14, 241.55, 218.62,
       725.00, 48.61, 204.77, 710.67, 8.75, 225.37, 123.82,
       25.31, 588.26, 27.90, 197.68, 281.83, 370.61, 371.34,
       229.94, 240.12, 389.96, 725.00, 100.45, 564.15, 29.40,
       40.30, 142.98, 350.30, 41.68, 260.81, 369.12, 134.54,
       312.08, 725.00, 253.15, 70.50, 452.59, 14.82, 327.22,
       119.42, 81.01, 68.25, 90.84, 725.00, 2.39, 160.67, 86.55,
       55.43, 369.39, 107.23, 93.39, 725.00, 725.00, 42.20,
       138.52, 191.94, 266.05, 372.72, 52.36, 111.30)

## On utilise 'coverage' pour obtenir la densité des données
## modifiées.
f <- coverage(dpareto, ppareto, deductible = 75, limit = 800)

## On utilise la fonction obtenue ci-dessus dans 'fitdistr' comme
## n'importe quelle autre fonction de densité.
fitdistr(x, f, start = list(shape = 1, scale = 1), method = "N")

## EXEMPLE 5.14
##
## On a des données groupées.
(x <- grouped.data(cj = c(0, 1, 2, 4, 8, 12, 16, 20, Inf),
                   nj = c(4, 3, 3, 4, 2, 0, 1, 3)))

## Sans méthode numérique, il est difficilement envisageable de
## maximiser la fonction de log-vraisemblance de données
## groupées. Puisque 'fitdistr' ne supporte pas les données
## groupées, on va utiliser les fonctions d'optimisation
## directement.
##
## Pour la distribution exponentielle, qui ne compte qu'un seul
## paramètre, il est préférable, pour des raisons de stabilité,
## de minimiser la log-vraisemblance négative avec 'optimize'.
ll <- function(p, x)
    -drop(crossprod(x[, 2], log(diff(pexp(x[, 1], p)))))
optimize(ll, lower = 0, upper = 2, x = x)

## Pour la distribution gamma, on utilise 'optim'.
ll <- function(p, x)
    -drop(crossprod(x[, 2], log(diff(pgamma(x[, 1], p[1], p[2])))))
optim(c(1, 1), ll, x = x)

## EXEMPLE 5.18
##
## On va estimer le mode d'une loi de Pareto inverse. Tout
## d'abord, on se donne un échantillon aléatoire.
x <- c(90.82003234, 231.758342, 173.4952009, 54.7016874,
       54.38717678, 66.55649132, 64.70525857, 32.11372382,
       35.88995236, 26.64007571, 8.280677022, 83.11710111,
       29.28489668, 111.4226552, 333.1536616, 15.12569074,
       20.51796335, 1528.253204, 3949.025475, 157.9228822,
       589.2324663, 19.36586191, 240.2328439, 933.7527217,
       17.30204671, 74.09253268, 415.8841427, 105.1575175,
       107.0157345, 26.10984817, 122.0857254, 5741.30212,
       103.0847097, 45.98989544, 72.65399999, 164.0558806,
       22.70259283, 134.9358282, 46.27191635, 21.16168539,
       197.7311518, 370.8642329, 24.64028934, 158.6333192,
       265.8701389, 36.57753616, 93.74525458, 78.60172397,
       414.4440064, 27.38132725, 19.06459196, 674.4456707,
       35.19132876, 142.709182, 133.6359018, 36.93977257,
       776.530798, 16.76115168, 156.5600435, 611.6450772,
       39.40947269, 63.68927339, 7.940722739, 369.4104142,
       80.48188255, 16.0094895, 42.00656883, 40.99255559,
       476.4875828, 49.38945828, 6.619740386, 23.99096566,
       82.07584813, 115.3190035, 52.15234121, 92.26137298,
       74.27839338, 48.19953415, 862.6692288, 25.62765813,
       32.54815008, 101.2846802, 156.8140847, 17.51911039,
       25.5251894, 48.68906566, 29.34124106, 34.95065775,
       26.81550197, 66.34696211, 1815.299926, 19.67448744,
       13.45007344, 44.73622845, 31.62093256, 30.81908273,
       148.7958437, 20.07293494, 609.9016668, 27.14996816)

## Pour fins de comparaison, nous allons calculer les EMV des
## paramètres de forme et d'échelle d'abord en utilisant la
## formule explicite obtenue dans l'exemple, puis par
## minimisation numérique de la fonction de log-vraisemblance
## négative.
##
## Dans le premier cas, on doit d'abord calculer l'estimateur du
## paramètre d'échelle numériquement. Pour ce faire, on définit
## la fonction dont on doit trouver la racine. Nous avons choisi,
## ici, la seconde fonction de score.
f <- function(scale, x)
{
    n <- length(x)
    xps <- x + scale
    shape <- n/sum(log(xps) - log(x))
    n/scale - (shape + 1) * sum(1/xps)
}

## On trouve ensuite la racine de cette fonction avec 'uniroot',
## ce qui donne l'EMV du paramètre d'échelle. Puis, on calcule
## l'EMV du paramètre de forme à partir de la formule obtenue
## dans l'exemple.
(hscale <- uniroot(f, lower = 2, upper = 4, x = x)$root)
(hshape <- length(x)/sum(log(x + hscale) - log(x)))

## Puisque nous avons obtenu la formule explicite de la matrice
## d'information, on peut calculer son estimation avec les
## estimateurs ci-dessus.
n <- length(x)
matrix(c(n/hshape^2,
         rep(n/(hscale * (hshape + 1)), 2),
         n * hshape/(hscale^2 * (hshape + 2))),
       nrow = 2)

## On se tourne maintenant vers l'approche entièrement numérique.
fit <- fitdistr(x, dinvpareto, start = list(shape = 1, scale = 1))
fit$estimate                  # estimateurs
solve(fit$vcov)               # information observée

## Comparaisons de l'histogramme des données et de la
## distribution ajustée: tout d'abord pour toute l'étendue des
## données, puis seulement pour le coeur de la distribution.
br <- c(0, 25, 50, 100, 250, 500, 1000, 2000, 4000, 6000)
hist(x, breaks = br)
curve(dinvpareto(x, fit$estimate[1], fit$estimate[2]),
      from = 0.1, add = TRUE, col = "blue", lwd = 2)

hist(x, breaks = br, xlim = c(0, 1000))
curve(dinvpareto(x, fit$estimate[1], fit$estimate[2]),
      from = 0.1, add = TRUE, col = "blue", lwd = 2)

## Nous avons obtenu essentiellement les mêmes résultats par
## l'approche entièrement numérique. Nous utiliserons donc les
## valeurs de l'objet 'fit' dans la suite.
##
## Le calcul d'un l'intervalle de confiance à 95 % pour le mode
## exige quelques lignes de programmation.
(m <- fit$estimate[2] * (fit$estimate[1] - 1)/2) # mode estimé
h <- c(fit$estimate[2], fit$estimate[1] - 1)/2 # gradient estimé
s <- sqrt(drop(crossprod(h, fit$vcov)) %*%  h) # écart-type estimé
c(m - 1.96 * s, m + 1.96 *s)                   # intervalle

###
### ESTIMATION PAR DISTANCE MINIMALE
###

## L'interface de la fonction 'mde' de actuar est très similaire
## à celle de 'fitdistr'. Outre les donnée, la fonction requiert
## en argument:
##
## - la mesure de distance à utiliser ("CvM", "chi-square" ou
##   "LAS");
## - une fonction pour calculer la fonction de répartition
##   théorique ou l'espérance limitée théorique;
## - des valeurs de départ;
## - des poids, le cas échéant.
##
## On va ajuster par la méthode de la distance minimale une
## distribution exponentielle aux données groupées d'assurance
## dentaire.
gdental

## La moyenne des données nous donnera une idée de la valeur de
## départ à fournir à la fonction de minimisation de distance.
mean(gdental)

## Estimateur de la distance de Cramér-von Mises. On peut
## utiliser des données individuelles ou des données groupées
## avec cette distance. On fournit à 'mde' la fonction de
## répartition théorique; 'mde' se chargera de construire l'ogive
## et la fonction de distance à minimiser, puis d'appler 'optim'
## pour effectuer la minimisation numérique.
mde(gdental, pexp, start = list(rate = 1/200), measure = "CvM")

## Pour éviter l'avertissement lors d'une optimisation sur un
## seul paramètre, on peut utiliser la méthode de type
## quasi-Newton "BFGS".
mde(gdental, pexp, start = list(rate = 1/200),
    measure = "CvM", method = "BFGS")

## Estimateur de la distance du khi carré modifié.
mde(gdental, pexp, start = list(rate = 1/200),
    measure = "chi-square")

## Estimateur de la distance de la sévérité moyenne par couche.
mde(gdental, levexp, start = list(rate = 1/200),
    measure = "LAS")

## La minimisation ne réussit pas toujours aussi bien que
## ci-dessus. En fait, les techniques de distance minimale sont
## plutôt instables numériquement. Par exemple, si l'on essaie
## plutôt d'ajuster une loi de Pareto aux données, l'optimisation
## ne converge pas.
mde(gdental, ppareto, start = list(shape = 3, scale = 600),
    measure = "CvM")

## Tout comme pour le maximum de vraisemblance, travailler avec
## le logarithme des paramètres peut aider.
f <- function(x, lshape, lscale)
    ppareto(x, exp(lshape), exp(lscale))
(p <- mde(gdental, f, measure = "CvM",
          start = list(lshape = log(3), lscale = log(600))))
exp(p$estimate)

## Superposition de l'histogramme des données et de la
## distribution de Pareto ajustée.
hist(gdental)
curve(dpareto(x, exp(p$estimate[1]), exp(p$estimate[2])), from = 0.1,
      add = TRUE, col = "blue", lwd = 2)
