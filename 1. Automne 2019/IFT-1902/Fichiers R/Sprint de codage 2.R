### Sprint de codage 2
## Olivier Bourret
## Émile Dumont
## William Kokis



### Question 1

?HairEyeColor    #Consulter l'aide de HairEyeColor

## a) Nombre de personnes aux yeux verts en fonction de leurs yeux et de leurs genres.

HairEyeColor[ , 4, ]

## b) Nombre de personnes ayant les cheveux bruns et les yeux noisette en fonction de leur genres.

HairEyeColor[ 2, 3, ]

## c) Nombre de femmes rousses aux yeux verts

HairEyeColor[ 3, 4, 2 ]

## d) Combiner les deux tableaux pour ne pas distinguer le sexe

apply(HairEyeColor, c(1,2), sum)

## e) Nombre total d'hommes et de femmes au total dans l'étude

sum(HairEyeColor)



### Question numéro 2

## La fonction mortgage(P, n, i, open = FALSE), où P représente le prêt, n le temps en mois,
## i qui est le taux préférentiel nominal annuel et open représente si le prêt est ouvert ou fermé.
## Cette fonction permet de calculer le remboursement mensuel.

mortgage <-  function(P, n, i, open = FALSE){
    
    if( open == TRUE){
        j <- ((i + 0.04) / 12 )
        return(( P * j ) / ( 1- (1 + j) ^(-n)))
    }
    
    else{
        j <- (( i + 0.01 ) / 12)
        return(( P * j ) / ( 1- (1 + j) ^(-n)))
    }
}

## Test pour les deux cas (Exemples d'utilisation)
mortgage(300000, 300, 0.03, open = TRUE)
mortgage(200000, 120, 0.025)

