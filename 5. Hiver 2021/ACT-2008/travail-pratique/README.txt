===
=== ACT-2008 MATHÉMATIQUES ACTUARIELLES IARD II
===
=== TRAVAIL PRATIQUE
===

INTRODUCTION

La présente archive contient les fichiers suivants:

- 'travail-pratique.pdf', l'énoncé du travail.

- 'resultats-complets.csv', les résultats complets de 2000 rondes de
  golf.

- 'resultats-partiels.csv', les résultats partiels de 600 rondes de
  golf assimilables à des parties en cours.

- 'normales.csv', les normales (par) des 18 trous du Club de golf
  Beaconsfield.

- 'validate.sh', un script Bash de validation du dépôt et des
  différents livrables du travail. Les instructions d'utilisation se
  trouvent ci-dessous.

- 'validateconf-rapport-1', 'validateconf-rapport-2',
  'validateconf-rapport-3' et 'validateconf-livraison', les fichiers
  de configuration du script de validation pour chaque livrable.

- 'lib/*.sh', la bibliothèque de fonctions du script de validation.

- COPYING, le texte de la GNU General Public Licence sous laquelle est
  publié le script 'validate.sh'.

- LICENSE, le texte de la licence CC BY-SA sous laquelle est publié
  l'énoncé du travail.

- VERSION, les numéros de révision Git du matériel.

UTILISATION DU SCRIPT DE VALIDATION

Le script de validation 'validate.sh' s'emploie depuis une ligne de
commande Bash. Pour ce faire, vous devez:

1. enregistrer les fichiers 'validate.sh', 'validateconf-rapport-1',
   'validateconf-rapport-2', 'validateconf-rapport-3' et
   'validateconf-livraison', ainsi que le répertoire 'lib' et tout son
   contenu quelque part sur votre disque (recommandation: dans le
   répertoire du dépôt Git);

2. ajouter au script le droit d'exécution avec

     chmod u+x validate.sh

3. (** Seulement pour les utilisateurs de Windows dont Bash n'est pas
   configuré pour R **)

   i) localiser le fichier R.exe sur votre poste de travail,
      normalement dans C:\Program Files\R\R-x.y.z\bin, où x.y.z est le
      numéro de version de R;

   ii) ajouter le chemin d'accès (absolu) vers R.exe à la variable
       d'environnement PATH de Bash avec

       PATH="/c/Program Files/R/R-x.y.z/bin/":$PATH

       (remplacer x.y.z par le numéro de version approprié).

4. lancer le script avec en argument le nom du dépôt à valider et en
   spécifiant, à l'aide de l'option '-c', le nom du fichier de
   configuration de la phase à valider; utiliser l'option '-h' pour
   consulter l'aide complète du programme.

Exemples

La commande

  ./validate.sh -c validateconf-rapport-1 .

valide le rapport d'étape 1 du dépôt dans le répertoire courant
(identifié par « . »).

La commande

  ./validate.sh -c validateconf-livraison ~/111555555_equipe42

valide la livraison finale du dépôt situé dans le répertoire
~/111555555_equipe42.
