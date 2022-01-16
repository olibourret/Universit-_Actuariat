## La division entière retourne la partie entière de la
## division d'un nombre par un autre.
5 %/% 1:5
10 %/% 1:15

## L'opérateur à utiliser pour vérifier si deux valeurs sont
## égales est '==', et non '='. Utiliser le mauvais opérateur
## est une erreur commune --- et qui peut être difficile à
## détecter --- lorsque l'on programme en R.
##! 5 = 2                      # erreur de syntaxe

5 == 2                     # comparaison
y = 2                      # pas un test...
y                          # ... plutôt une affectation
