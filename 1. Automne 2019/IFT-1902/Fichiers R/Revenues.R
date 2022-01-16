### Travail longitudinal
### Olivier Bourret
### IDUL: 111 005 475

### Évaluation des revenus


## Construction d'un tableau semblable à import_data pour 
## contruire et valider l'objectif des fonctions

data <- data.frame(start_date = as.Date("2019-05-09"),
                   start_station_code = as.factor(c(6181, 6224, 6229, 6009, 6903,
                                                    6033, 6070, 6343, 6009, 6224)),
                   end_date = as.Date("2019-05-09"),
                   end_station_code = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                  6009, 6009, 6070, 6343, 6903)),
                   duration_sec = c(1000, 2404, 6116, 1800, 874, 4100, 2900, 2000, 2700, 2701),
                   is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))

### Construction de la fonction tariff_A2019r1

a = data[,5] # Définir le vecteur "a" qui contient le temps de chaque utilisation


## Fonction du coût de chaque utilisation (pour r1)

price_r1 <- function(x){
  if (x < 1800){                   # tarif pour moins de 30 minutes
    price_r1 <-  2.95
  }
  else if(x >= 1800 & x <= 2700){   # tarif de 30 à 45 minutes
    price_r1 <- 4.75
  }
  else{
    price_r1 <- (-3 * floor(( -1/900 ) * ( x - 2700 )) + 4.75 )   # tarif plus de 45 minutes
  }
}

tariff_A2019r1 <- sapply( a , price_r1 )  ## Fonction sapply pour appliquer la fonction
                                          ## price_r1 à tous les éléments du vecteur "a"
 



### Construction de la fonction tariff_A2019r2

price_r2 <- function(a){
  if (a <= 1800){                # tarif pour 30 minutes et moins 
    0.00109 * a + 0.57
  }
  else{
    pmin(( 0.00299 * ( a - 1800) + 2.532 ), 10.50 )   # tarif pour plus de 30 minutes   
  }
}

list <- sapply(a,price_r2)       ## Fonction sapply pour appliquer la fonction
                                 ## price_r2 à tous les éléments du vecteur "a"


tariff_A2019r2 <- round(list,2)      # Réponse arrondie à 2 chiffres après la virgule 
                                     # (Puisqu'on parle d'argent)


### Construction de la fonction revenues

revenuesr1 <- sum(tariff_A2019r1)    # Somme des revenus de tariff_A2019r1
revenuesr2 <- sum(tariff_A2019r2)    # Somme des revenus de tariff_A2019r2


revenues <- data.frame("Première tarification" = revenuesr1,     # Je l'ai mis dans un tableau,
                       "Deuxième tarification" = revenuesr2)     # car je trouve que c'est plus 
                                                                 # joli et agréable à lire




