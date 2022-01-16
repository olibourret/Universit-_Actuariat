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

## Pour illustrer les procédures d'importation et
## d'exportation de données, nous allons d'abord exporter des
## données dans des fichiers pour ensuite les importer.
##
## Les fichiers seront créés dans le répertoire de travail de
## R. La commande
##
##   getwd()
##
## affiche le nom de ce répertoire.
##
## Après chaque création de fichier d'exportation, ci-dessous,
## ouvrir le fichier correspondant dans votre éditeur pour
## voir les résultats.
##
## Débutons par l'exportation d'un vecteur simple créé à
## partir d'un échantillon aléatoire des nombres de 1 à 100.
(x <- sample(1:100, 20))

## Exportation avec la fonction 'cat' sans commentaires dans
## le fichier, les données les unes à la suite des autres sur
## une seule ligne.
cat(x, file = "vecteur.data")

## Pour placer des commentaires au début du fichier, il suffit
## d'exporter deux objets: la chaine de caractères contenant
## le commentaire et le vecteur. Ici, nous insérons un retour
## à la ligne entre chaque élément.
cat("# commentaire", x, file = "vecteur.data", sep = "\n")

## La fonction 'write' permet de disposer les données
## exportées en colonnes (cinq par défaut), un peu comme une
## matrice. Exportons exactement le même vecteur de données en
## lui donnant l'apparence d'une matrice 5 x 4 (remplie par
## ligne).
write(x, file = "matrice.data", ncolumns = 4)

## Pour insérer des commentaires au début du fichier créé avec
## 'write', le plus simple consiste à procéder en deux étapes:
## on crée d'abord un fichier ne contenant que le commentaire
## (et le retour à la ligne) avec 'cat', puis on y ajoute les
## données avec 'write' en spécifiant 'append = TRUE' pour
## éviter d'écraser le contenu du fichier.
cat("# commentaire\n", file = "matrice.data")
write(x, file = "matrice.data", ncolumns = 4, append = TRUE)

## Pour illustrer l'exportation avec 'write.table',
## 'write.csv' et 'write.csv2', nous allons exporter le jeu de
## données 'USArrests' utilisé précédemment.
##
## Les titres des lignes sont importants dans ce jeu de
## données puisqu'ils contiennent les noms des États. Par
## défaut, les fonctions exportent tant les titres de lignes
## que les titres de colonnes.
##
## 'write.table' utilise l'espace comme séparateur des champs
## et le point comme séparateur décimal.
write.table(USArrests, "USArrests.txt")

## 'write.csv' utilise la virgule comme séparateur des champs
## et le point comme séparateur décimal.
write.csv(USArrests, "USArrests.csv")

## 'write.csv2' utilise le point-virgule comme séparateur des
## champs et la virgule comme séparateur décimal.
write.csv2(USArrests, "USArrests.csv2")

## Importons maintenant toutes ces données dans notre espace
## de travail.
##
## Les données de 'vecteur.data' (en passant, l'extension dans
## le nom de fichier n'a aucune importance) sont lues et
## importées avec la fonction 'scan'.
##
## Nous devons indiquer à la fonction que la ligne débutant
## par un # est un commentaire.
(x <- scan("vecteur.data", comment.char = "#"))

## La fonction 'scan' permet aussi de lire les données de
## 'matrice.data'. La disposition des données dans le fichier
## n'a aucune importance pour 'scan'. Il faut donc en recréer
## la structure dans R.
##
## Cette fois, nous sautons simplement la ligne du fichier
## pour omettre le commentaire.
(x <- matrix(scan("matrice.data", skip = 1),
             nrow = 5, ncol = 4, byrow = TRUE))

## L'importation des données de 'USArrests.txt',
## 'USArrests.csv' et 'USArrests.csv2' est très simple avec
## les fonctions 'read.table', 'read.csv' et 'read.csv2'.
##
## Prenez toutefois note: l'importation de données n'est pas
## toujours aussi simple. Il faut souvent avoir recours aux
## multiples autres arguments de 'read.table'
read.table("USArrests.txt")
read.csv("USArrests.csv")
read.csv2("USArrests.csv2")

## Nettoyage: la fonction 'unlink' supprime les fichiers
## spécifiés en argument, ici ceux créés précédemment dans le
## répertoire de travail.
unlink(c("vecteur.data", "matrice.data",
         "USArrests.txt", "USArrests.csv", "USArrests.csv2"))
