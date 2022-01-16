### Utilisation de la fonction cm
library(actuar)

## Complément d'informations sur la crédibilité
vignette("credibility")




# Construction d'un tableau de données. Doit contenir le contrat, les ratios et les poids.
#'[*** Le modèle fonctionne aussi pour des données manquantes. NA représente une donnée manquante.]
donnees <- data.frame("Contrat"= c(1,2,3),
                      "ratio.1"= c(3,6,NA),  
                      "ratio.2"= c(5,8,2),    # Le tableau est bâti en colonnes, donc ratio.i représente le ratio
                      "ratio.3"= c(NA,8,0),   # de la i^e annnée de chaque contrat. Même principe pour les poids.i
                      "ratio.4"= c(NA,14,3),
                      "ratio.5"= c(4,4,6),
                      "poids.1"= c(1,2,NA),
                      "poids.2"= c(1,2,3),    # Ajouter des ratios, des poids et des contrats au besoin
                      "poids.3"= c(NA,2,3),
                      "poids.4"= c(NA,2,3),
                      "poids.5"= c(1,2,3))


## Utilisation du modèle de Bühlmann
fit.BS <- cm(~Contrat, donnees,           # Pour utiliser le modèle de Bühlmann, on fait comme le modèle de 
             ratios = ratio.1:ratio.4)    # Bühlmann-Straub, mais sans assigner de poids au modèle.
                                          #'[S'assurer de changer le nombre de colonnes]  
summary(fit.BS)




## Utilisation du modèle de Bühlmann-Straub
fit.BS <- cm(~Contrat, donnees,         
              ratios = ratio.1:ratio.5,    #'[S'assurer de changer le nombre de colonnes]
              weights = poids.1:poids.5,   
              method = "Buhlmann-Gisler") ### Méthode par défaut, alors il n'est pas nécessaire de préciser la méthode.

summary(fit.BS)



## Utilisation du pseudo estimateur Bichsel-Straub (avec a~)
fit.BSiter <- cm(~Contrat, donnees, 
                 ratios = ratio.1:ratio.4,   #'[S'assurer de changer le nombre de colonnes]
                 weights = poids.1:poids.4,
                 method = "iterative")       # Méthode "iterative" permet l'utilisation du pseudo estimateur Bichsel-Straub

summary(fit.BSiter)



