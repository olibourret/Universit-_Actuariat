### Sprint de codage 1 ACT-2002
###
### Équipe 9
### Olivier Bourret
### Félix Laflamme
### William Perron
### Simon Veilleux


Sf <- rcomppois(1e7, lambda = 0.003, rlnorm(meanlog = 7, sdlog = 1))  # Calcul de 10 millions de cas de réclamations possibles pour le feu
Se <- rcomppois(1e7, lambda = 0.050, rpareto(shape = 4, scale =  4500)) # Calcul de 10 millions de cas de réclamations possibles pour l'eau
Sb <- rcomppois(1e7, lambda = 0.080, rgamma(shape = 2.5, rate = 0.01)) # Calcul de 10 millions de cas de réclamations possibles pour le bris accidentel

S <- Sf + Se + Sb # Somme des trois Poisson composées

mean(S) # Calcul de la prime pure

mean(S[S > quantile(S, 0.75, type = 1)]) # Calcul de la prime de chargement de sécurité.


