#!/bin/bash

## Variables globales immuables
SCRIPTNAME=$(basename -- "$0")
SCRIPTDIR=$(dirname -- "$0")
DOC_REQUEST=70

## Variables globales par défaut
SCRIPTCONF=${SCRIPTNAME/%.sh/conf}

###
### Documentation
###
if [ $# -eq 0 ]
then
    cat <<USAGEXX
Usage: ${SCRIPTNAME} [options...] <répertoire>
-c <fichier>, --config-file=<fichier> 
                           Utiliser <fichier> comme fichier de 
                           configuration
-h, --help                 Afficher l'aide complète
-n, --no-check-local-repos Ignorer l'état du dépôt local
USAGEXX
    exit ${DOC_REQUEST}
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    cat <<MANPAGEXX
NOM

${SCRIPTNAME} - valide le dépôt et les fichiers d'un travail

SYNOPSYS

${SCRIPTNAME} [-c <fichier>|--config-file=<fichier>] [-h|--help]
            [-n|--no-check-local-repos] <répertoire>

DESCRIPTION

Effectue des vérifications pour le travail dans le répertoire en
argument: état du dépôt Git (le cas échéant); contenu d'un fichier de
code informatique; contenu d'un fichier de texte brut.

Les vérifications sur l'état d'un dépôt Git tel que publié sur
'origin' sont les suivantes:

  - le dépôt n'est pas vide;
  - la branche principale existe;
  - la liste des contributeurs est affichée;
  - au moins une branche autre que la branche principale existe, le
    cas échéant;
  - le nombre minimal de fusions dans la branche principale est
    atteint, le cas échéant
  - le nombre minimal d'archives est atteint, le cas échéant.

Les vérifications sur un fichier de code informatique sont les
suivantes:

  - le fichier existe et n'est pas vide;
  - le codage de caractères du fichier est ASCII ou UTF-8;
  - le fichier est portable;
  - le fichier peut être analysé dans le langage du code source.

Les vérifications sur un fichier de texte brut sont les suivantes:

  - le fichier existe et n'est pas vide;
  - le codage de caractères du fichier est ASCII ou UTF-8.

Les options suivantes sont disponibles:

-c <fichier>, --config-file=<fichier>
       Utiliser <fichier> comme fichier de configuration plutôt que le
       fichier par défaut '${SCRIPTNAME/%.sh/conf}'. Cette option
       permet d'utiliser une configuration spécifique à un stade, une
       partie ou une phase d'une travail.

-h, --help
       Afficher ce texte d'aide.

-n, --no-check-local-repos
       Omettre la vérification qu'il n'y a pas de changements non
       archivés et d'archives non publiées sur le serveur. Ces
       vérifications sont utiles lors de la validation d'un dépôt
       en développement, mais pas pour un dépôt cloné.

CONFIGURATION

Le fichier de configuration établit la carte de la validation à l'aide
d'une classification hiérarchique de clés et de valeurs.

Le format du fichier de configuration est le suivant:

catégorie
  sujet
    clé: valeur

Une ligne débutant par un '#' est considérée comme un commentaire et
est ignorée. L'indendation de *deux* espaces est obligatoire pour
créer un nouveau niveau de classification.

La configuration doit obligatoirement contenir une catégorie spéciale
'__global' structurée ainsi (les niveaux entre [ ] sont optionnels):

__global
  [repository]
    check_repos: <true|false>
    pattern_name: <motif>
    omit_authors: <motif>
    [branch]
      check_branch_other_main: <true|false>
    [merged]
      check_merged: <true|false>
      nb_merged_min: <nombre de fusions>
    [commits]
      check_commits: <true|false>
      nb_commits_min: <nombre d'archives>
    [tag]
      checkout_by_tag: <true|false>
      tag_name: <nom>
  [encoding]
    check_encoding: <true|false>

Les autres catégories de la configuration identifient des fichiers de
texte ou de code informatique à corriger selon la structure suivante:

<fichier>
  code: <true|false>
  [shinyapp: <true|false>]

La clé 'code' indique si un fichier contient du code informatique ou
non. La clé 'shinyapp' indique que <fichier> est en fait un répertoire
contenant une application Shiny.

Les fichiers sont validés en ordre lexicographique. Pour contrôler
l'ordre, il est possible de précéder leur nom de 'n-', où 'n' est un
entier (avec ou sans zéros à gauche). Ce préfixe est ignoré pour le
traitement et l'affichage.

FICHIERS

L'exécution de ce script requiert que les fichiers suivants se
trouvent dans le répertoire courant:

- ${SCRIPTNAME/%.sh/conf} ou le fichier spécifié avec l'option '-c',
  la configuration du script;
- lib/branches.sh, lib/error.sh, lib/files.sh, lib/grading.sh,
  lib/io.sh, lib/map.sh, lib/repository.sh, lib/source.sh.

ENVIRONNEMENT

Pour valider du code informatique R, le script doit pouvoir appeler
l'interpréteur R. Le programme doit donc se trouver dans un endroit
mentionné dans la variable d'environnement 'PATH'.

EXEMPLES

La commande

  ./${SCRIPTNAME} .

valide le dépôt du répertoire courant.

La commande

  ./${SCRIPTNAME} -c validadeconf-prototype ~/111555555_equipe42

valide le travail dans le répertoire ~/111555555_equipe42 sur la base
de la configuration spécifiée le fichier 'validateconf-prototype'.
MANPAGEXX
    exit ${DOC_REQUEST}
fi

###
### Fonctions
###

. ${SCRIPTDIR}/lib/branches.sh
. ${SCRIPTDIR}/lib/error.sh
. ${SCRIPTDIR}/lib/files.sh
. ${SCRIPTDIR}/lib/io.sh
. ${SCRIPTDIR}/lib/map.sh
. ${SCRIPTDIR}/lib/repository.sh
. ${SCRIPTDIR}/lib/source.sh
. ${SCRIPTDIR}/lib/validation.sh

###
### Actions du script
###

## Traitement des options et des arguments.
while [ $# -gt 0 ]
do
    case $1 in
        -c)
	    SCRIPTCONF="$2"; shift
	    ;;
	--config-file=*)
	    SCRIPTCONF="${1#*=}"
	    ;;
        -n|--no-check-local-repos)
            CHECK_LOCAL_REPOS=false
            ;;
        *)
            break;;
    esac
    shift
done

## Récupérer le nom du répertoire à valider qui est maintenant le
## premier argument du script.
REPOS="$1"

## Terminer s'il n'y a aucun nom de répertoire en argument.
[ -z "${REPOS}" ] && { error_exit "nom de répertoire manquant"; }

## Terminer si le fichier de configuration est introuvable.
[ ! -f "${SCRIPTCONF}" ] &&
    error_exit "fichier de configuration introuvable"

## Mettre en place la carte de correction dans un répertoire
## temporaire.
MAPDIR="$(mktemp -d -t ${SCRIPTNAME})/"
mkmap "${MAPDIR}" "${SCRIPTCONF}" ||
    error_exit "mise en place de la carte de correction impossible"
trap 'rm -r ${MAPDIR}' EXIT

## Récupération des variables globales dans la carte de correction.
## (La définition de valeurs par défaut exige une seconde expression
## car les substitutions imbriquées ne sont pas permises dans Bash.)
CHECK_REPOS=$(mapget "${MAPDIR}/__global/repository" "check_repos")
CHECK_REPOS=${CHECK_REPOS:-false}
if ${CHECK_REPOS}
then
    REPOS_NAME_PATTERN=$(mapget "${MAPDIR}/__global/repository" "pattern_name")
    REPOS_NAME_PATTERN=${REPOS_NAME_PATTERN:-.*}     # n'importe quoi par défaut
    OMIT_AUTHORS_PATTERN=$(mapget "${MAPDIR}/__global/repository" "omit_authors")
    OMIT_AUTHORS_PATTERN=${OMIT_AUTHORS_PATTERN:-^$} # omettre aucun par défaut
    CHECK_BRANCH_OTHER_MAIN=$(mapget "${MAPDIR}/__global/repository/branch" "check_branch_other_main")
    CHECK_BRANCH_OTHER_MAIN=${CHECK_BRANCH_OTHER_MAIN:-false}
    CHECK_MERGED=$(mapget "${MAPDIR}/__global/repository/merged" "check_merged")
    CHECK_MERGED=${CHECK_MERGED:-false}
    if ${CHECK_MERGED}
    then
	NB_MERGED_MIN=$(mapget "${MAPDIR}/__global/repository/merged" "nb_merged_min")
    fi
    CHECK_COMMITS=$(mapget "${MAPDIR}/__global/repository/commits" "check_commits")
    CHECK_COMMITS=${CHECK_COMMITS:-false}
    if ${CHECK_COMMITS}
    then
	NB_COMMITS_MIN=$(mapget "${MAPDIR}/__global/repository/commits" "nb_commits_min")
    fi
    CHECKOUT_BY_TAG=$(mapget "${MAPDIR}/__global/repository/tag" "checkout_by_tag")
    CHECKOUT_BY_TAG=${CHECKOUT_BY_TAG:-false}
    if ${CHECKOUT_BY_TAG}
    then
	TAG_NAME=$(mapget "${MAPDIR}/__global/repository/tag" "tag_name")
    fi
fi
CHECK_ENCODING=$(mapget "${MAPDIR}/__global/encoding" "check_encoding")
CHECK_ENCODING=${CHECK_ENCODING:-false}

## Démarrer un sous-shell pour exécuter la validation dans le
## répertoire en argument.
(
    ## Changer de répertoire courant.
    cd "${REPOS}" > /dev/null 2>&1 || \
	error_exit "aucun répertoire: ${REPOS}"
    
    ## Validation du dépôt Git, le cas échéant.
    if ${CHECK_REPOS}
    then
	print_msg "Validation de l'intégrité du dépôt publié sur 'origin'\n"
	if ${CHECK_LOCAL_REPOS:-true}
	then
	    ## Vérifier s'il y a des modifications non archivées dans
	    ## le dépôt local; terminer si c'est le cas.
	    validate_no_uncommitted || exit 1

	    ## Vérifier s'il y a archives non publiées sur le serveur
	    ## dans le dépôt local; terminer si c'est le cas.
	    validate_no_unpushed || exit 1
	fi
	
	## Obtenir le nom de la branche principale.
	MAIN=$(get_main_name)
	
	## Vérifier que le dépôt comporte une branche principale;
	## terminer si ce n'est pas le cas.
	validate_valid_main "${MAIN}" || exit 1
	
	## Vérifier que la branche (locale) courante est la branche
	## principale; terminer si ce n'est pas le cas.
	validate_on_main "${MAIN}" || exit 1

	## Vérifier que le nom du dépôt correspond au motif fourni
	## dans la configuration; terminer si ce n'est pas le cas.
	validate_repos_name "${REPOS_NAME_PATTERN}" || exit 1

	## Vérifier que le dépôt contient des fichiers; terminer si ce
	## n'est pas le cas.
	validate_repos_laden || exit 1

	## Vérifier que la branche principale existe sur le serveur;
	## terminer si ce n'est pas le cas.
	validate_branch_exists "origin/${MAIN}" || exit 1

	## Afficher la liste des contributeurs au projet.
	validate_contrib "${OMIT_AUTHORS_PATTERN}"
	
	## Vérifier que le dépôt contient au moins une branche autre
	## que la branche principale, le cas échéant.
	if ${CHECK_BRANCH_OTHER_MAIN}
	then
	    validate_branch_other_than_exists "origin/${MAIN}"
	fi

	## Vérifier le nombre de fusions dans la branche principale,
	## le cas échéant.
	if ${CHECK_MERGED}
	then
	    validate_merged_in_branch "origin/${MAIN}" "${NB_MERGED_MIN}"
	fi

	## Vérifier le nombre d'archives, le cas échéant.
	if ${CHECK_COMMITS}
	then
	    validate_commits "${NB_COMMITS_MIN}"
	fi

	## Vérifier que le dépôt contient une étiquette appropriée, le
	## cas échéant; terminer si ce n'est pas le cas.
	if ${CHECKOUT_BY_TAG} && validate_tag_exists "${TAG_NAME}"
	then
	    git fetch --all --tags && \
	    git checkout "${TAG_NAME}" || \
		error_exit "impossible de basculer vers l'étiquette ${TAG_NAME}"
	fi
    fi
    
    ## Validation des fichiers de texte et de code informatique.
    ##
    ## Il faut ignorer le fichier spécial '__global'.
    for file in "${MAPDIR}"/[^_]*/
    do
	f=$(basename -- "${file}") # nom du fichier seul
	f="${f#[0-9]*-}"	   # sans préfixe de tri
	
	## Vérifier que le fichier existe; passer au prochain fichier
	## si ce n'est pas le cas.
	print_msg "Validation de ${f}\n"
	validate_file_exists "${f}" || continue

	## Le cas où le «fichier» est en fait le répertoire d'une
	## application Shiny doit être traité à part.
	if [ "$(mapget "${file}" "shinyapp")" = true ]
	then
	    ## Vérifier que le répertoire n'est pas vide; passer au
	    ## prochain fichier s'il est vide.
	    validate_dir_laden "${f}" || continue
	else
	    ## Vérifier que le fichier n'est pas vide; passer au
	    ## prochain fichier s'il est vide.
	    validate_file_laden "${f}" || continue
	    
	    ## Vérifier le codage de caractères du fichier, le cas
	    ## échéant (ce l'est habituellement).
	    if ${CHECK_ENCODING}
	    then
		validate_file_encoding "${f}"
	    fi
	fi

	## Si le fichier contient du code informatique, vérifier qu'il
	## est portable et analysable dans le langage du code source.
	if [ "$(mapget "${file}" "code")" = true ]
	then
	    validate_portable "${f}"
	    validate_source "${f}"
	fi
    done

    ## Si la validation a été effectuée pour une étiquette donnée,
    ## retourner à la branche principale avant de terminer.
    if ${CHECKOUT_BY_TAG}
    then
	git checkout -q "${MAIN}" || \
	    error_exit "impossible de revenir à la branche ${MAIN}"
    fi
)

exit $?
