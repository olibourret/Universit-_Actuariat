### Travail pratique 
## Modèles linéaires ACT-2003
## Équipe 14
## Olivier Bourret
## Félix Laflamme
## William Perron
## Simon Veilleux

# Importation des données(Ne pas oubler de set le working directionary)

modelingData <- read.csv("MODELING_DATA.csv", header = TRUE, sep =";") 

modelingDataModif <- modelingData[complete.cases(modelingData),] # Élimination des lignes vides


# Ajout de l'information Province à modelingData

Prov <- data.frame("1er Charactère"=c("A","B","C","E","G","H","J","K","L","M","N","P","R","S","T","V","X","Y"),
                        "Province"=c("NL","NS","PE","NB","QC","QC","QC","ON","ON","ON","ON","ON","MB","SK","AB","BC","NU/NT","YT"))

firstCharPostCod <- substr(modelingDataModif[,4],1,1)  ##Sélection du 1er caractère code postal

Province <- Prov[match(firstCharPostCod,Prov[,1]),2] #Sélection de la province en fonction du 1er caractère

modelingDataModif <- cbind(modelingDataModif,Province)



# Ajout de l'information territoire à modelingData (Urbain ou Rural)

secCharPostCod <- ifelse(as.numeric(substr(modelingDataModif[,4],2,2)) == 0, "R","U")
 
modelingDataModif <- cbind(modelingDataModif,secCharPostCod)


# Ajout de l'information âge à modelingData (en date de 2020)

Age_debut_inval <- modelingDataModif[,1]-modelingDataModif[,6]

modelingDataModif <- cbind(modelingDataModif,Age_debut_inval)


# Ajout de l'information saison de l'invalidité à modelingData

seasonTable <- data.frame("Numero mois"=c(1:12),"Saison"=c(rep.int("Hiver",3),rep.int("Printemps",3),rep.int("Ete",3),rep.int("Automne",3)))

Saison_debut_inval <- seasonTable[match(modelingDataModif[,2],seasonTable[,1]),2]

modelingDataModif <- cbind(modelingDataModif,Saison_debut_inval)


# Ajout de l'information Groupe du délai d'attente à modelingData

Delai_attente_Group <- c()
for (i in 1:length(modelingDataModif[,3])) {
    {if(modelingDataModif[i,3]<75){
        Delai_attente_Group[i] <- "Petit"
    }
    else if(modelingDataModif[i,3]>=150){
        Delai_attente_Group[i] <- "Grand"
    }
       else Delai_attente_Group[i] <- "Moyen"
    }
}

modelingDataModif <- cbind(modelingDataModif,Delai_attente_Group)










