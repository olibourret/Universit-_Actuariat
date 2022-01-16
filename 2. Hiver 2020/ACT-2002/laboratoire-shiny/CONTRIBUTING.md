<!-- Emacs: -*- coding: utf-8; eval: (auto-fill-mode -1); eval: (visual-line-mode t) -*- -->

# Collaborer au projet *Rapports dynamiques avec Shiny*

Pour collaborer au projet, vous devez publier vos modifications dans une nouvelle branche et effectuer une demande de tirage (*pull request*) vers la branche `master`. La procédure à suivre à partir d'une interface en ligne de commande (Git Bash sous Windows ou Terminal sous macOS) est la suivante.

1. Si  vous travaillez sur le code source pour la première fois, déplacez-vous avec la commande `cd` dans le répertoire dans lequel vous voulez enregistrer le code source du projet (le répertoire `laboratoire-shiny` sera créé automatiquement), clonez le dépôt et déplacez-vous ensuite dans le dossier du code source:

```
git clone https://gitlab.com/vigou3/laboratoire-shiny.git
cd laboratoire-shiny
```

**OU**

1. Si vous avez déjà cloné le dépôt dans le passé et que vous voulez reprendre le travail sur le code source, déplacez-vous avec la commande `cd` dans le répertoire du code source, puis mettez à jour votre copie locale du dépôt depuis la branche `master`:

```
git checkout master
git pull
```

2. Créez une branche (locale) pour vos modifications:

```
git checkout -b <nom_de_branche>
```
	
3. Effectuez maintenant vos modifications. On ne fait des modifications que dans un seul fichier à la fois! Une fois les modifications terminées, publiez le fichier modifié dans votre dépôt local avec un commentaire utile, mais bref, sur la nature des modifications:
    
```
git status
git add <fichier>
git commit -m "<commentaire>"
```

4. Publiez ensuite la branche avec les modifications dans le dépôt GitLab (vous devez y disposez d'un compte):

```
git push -u origin <nom_de_branche>
```
	
5. Finalement, connectez-vous à l'interface graphique de GitLab et faites une demande de tirage (*pull request*) vers la branche `master`.

6. Si vous avez d'autres modifications à proposer, reprenez la procédure depuis le début en utilisant une **branche différente**. Autrement, vos modifications seront combinées en une seule requête et il devient difficile de les sélectionner séparément.
