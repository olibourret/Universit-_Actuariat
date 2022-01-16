## Copyright (C) 2020 Vincent Goulet
##
## Ce fichier fait partie du projet
## «Plateforme de correction automatique des sprints»
## https://gitlab.com/vigou3/projet-cas
##
## Ce programme est un logiciel libre: vous pouvez le redistribuer ou
## le modifier suivant les termes de la GNU General Public License
## telle que publiée par la Free Software Foundation, soit la version
## 3 de la licence, soit (à votre gré) toute version ultérieure.
##
## Ce programme est distribué dans l'espoir qu'il sera utile, mais
## SANS AUCUNE GARANTIE; sans même la garantie tacite de QUALITÉ
## MARCHANDE ou d'ADÉQUATION À UN BUT PARTICULIER. Consultez la GNU
## General Public License pour plus de détails.
##
## Vous devriez avoir reçu une copie de la GNU General Public License
## en avec ce programme. Si ce n'est pas le cas, consultez
## <https://www.gnu.org/licenses>.

###
### uncommented_string_in_file <pattern> <filename>
###
##
##  Vérifier si le motif (d'expressions régulières étendues) <pattern>
##  correspond à une chaine de caractères dans <filename> ailleurs
##  qu'en commentaire.
##
uncommented_string_in_file ()
{
    grep -E "$1" "$2" | grep -E -q -v "(^#)|(#.*($1))"
}

###
### check_cmd <cmd>
###
##
##  Vérifier si <cmd> est disponible depuis la ligne de commande.
##
check_cmd ()
{
    command -v "$1" > /dev/null 2>&1
}

###
### check_portable <filename>
###
##
##  Vérifier que le fichier de script <filename> est portable.
##
##  Les vérifications suivantes sont effectuées:
##
##  - le fichier ne contient pas de commandes 'setwd' (applicable aux
##    script R seulement, mais normalement sans effet pour les
##    procédures d'interpréteur de commandes);
##  - le fichier ne contient pas de commandes 'install.packages'
##    (applicable aux script R seulement, mais normalement sans effet
##    pour les procédures d'interpréteur de commandes);
##  - le fichier ne contient pas de chemin d'accès local ('~/', '../'
##    ou chemin Windows du type 'C:\').
##
##  ERREUR STANDARD
##
##  Raisons qui rendent le fichier non portable, le cas échéant,
##  séparées par des retours à la ligne.
##
check_portable ()
{
    local msg=

    uncommented_string_in_file "setwd\([^)]*\)" "$1" && \
	{ msg+="appel à la fonction 'setwd'\n"; }

    uncommented_string_in_file "install\.packages\([^)]*\)" "$1" && \
	{ msg+="appel à la fonction 'install.packages'\n"; }

    uncommented_string_in_file "(~/)|(\.\./)|([A-Za-z]:[/\])" "$1" && \
	{ msg+="utilisation d'un chemin d'accès vers une ressource locale\n"; }

    [ -z "${msg}" ] || { error_return "${msg}"; }
}

###
### check_source <filename>
###
##
##  Vérifier le contenu d'un fichier de script.
##
##  Le type de vérification dépend du type du fichier <filename>:
##
##    répertoire: application Shiny
##    extensions .R, .r: script R
##    extensions .Rmd, .rmd: fichier R Markdown
##    extension .sh: procédure d'interpréteur de commandes Bash
##
##  ERREUR STANDARD
##
##  Erreur standard du processus de validation du code source.
##
check_source ()
{
    ## Les tests sont exécutés par des fonctions auxiliaires selon le
    ## type de fichier de script.
    if [ -d "$1" ]
    then
	check_source_shiny "$1"
	return $?
    fi

    case ${1##*.} in
	Rmd|rmd)
	    check_source_rmd "$1"
	    ;;
	R|r)
	    check_source_r_script "$1"
	    ;;
	sh)
	    check_source_shell_script "$1"
	    ;;
	*)
	    error_return "type de fichier de script non supporté"
	    ;;
    esac
}

###
### check_source_r_script <filename>
###
##
##  Vérifier que le fichier de script R <filename> est évaluable dans
##  R avec 'source'.
##
##  Vérifications préalables: possible de lancer R; le fichier ne
##  s'appelle pas lui même avec 'source'.
##
##  ERREUR STANDARD
##
##  Messages des vérifications préalables ou messages d'erreur de R,
##  le cas échéant.
##
check_source_r_script ()
{
    check_cmd R || \
	{ error_return "impossible de trouver R; configurez adéquatement votre terminal"; }

    uncommented_string_in_file "source\((\"$1\")|('$1')\)" "$1" && \
	{ error_return "le fichier s'appelle lui-même avec 'source'"; }

    R --quiet --no-restore -e "source('$1')" >/dev/null
}

###
### check_source_rmd <filename>
###
##
##  Vérifier la «compilation» du fichier R Markdown <filename>.
##
##  Vérification préalable: possible de lancer R.
##
##  ERREUR STANDARD
##
##  Messages des vérifications préalables ou messages d'erreur de R,
##  le cas échéant.
##
check_source_rmd ()
{
    check_cmd R || \
	{ error_return "impossible de trouver R; configurez adéquatement votre terminal"; }

    R --quiet --no-restore -e "rmarkdown::render('$1')" >/dev/null
}

###
### check_source_shiny <dirname>
###
##
##  Vérifier la «compilation» de l'application Shiny qui se trouve
##  dans le répertoire <dirname>.
##
##  Vérification préalable: possible de lancer R.
##
##  ERREUR STANDARD
##
##  Messages des vérifications préalables ou messages d'erreur de R,
##  le cas échéant.
##
check_source_shiny ()
{
    check_cmd R || \
	{ error_return "impossible de trouver R; configurez adéquatement votre terminal"; }

    echo "vérification des applications Shiny non encore prise en charge"
    return 1
    # R --quiet --no-restore -e "shiny::runApp('$1')" >/dev/null
}

###
### check_source_shell_script <filename>
###
##
##  Vérifier la validité de la syntaxe de la procédure d'interpréteur
##  <filename> avec l'interpréteur mentionné dans le shebang.
##
##  ERREUR STANDARD
##
##  Messages de l'interpréteur de commande.
##
check_source_shell_script ()
{
    case "$(sed '1s/#!//;q' "$1")" in
	/bin/sh)
	    /bin/sh -n "$1"
	    ;;
	/bin/bash)
	    /bin/bash -n "$1"
	    ;;
	*)
	    error_return "shell inconnu ou non supporté"
	    ;;
    esac
}

###
### check_criteria <testfile>
###
##
##  Vérifier la validité des tests contenus dans le fichier <testfile>
##  à l'aide du programme approprié selon le type du fichier.
##
##  Le type du fichier <testfile> est déterminé à partir de son
##  extension:
##
##    R, r: script R
##    sh: procédure d'interpréteur de commandes Bash
##
##  SORTIE STANDARD
##
##  Résultats du processus d'exécution des tests.
##
##  ERREUR STANDARD
##
##  Erreur standard du processus d'exécution des tests.
##
check_criteria ()
{
    ## Créer un lien symbolique vers le fichier <tests> dans le
    ## répertoire courant.
    ##
    ## Raison: dans R, 'tinytest::run_test_file' fait du répertoire où
    ## se trouve le fichier de tests le répertoire de travail.
    local testfile=___$(basename "$1")
    local extension="${testfile##*.}"
    ln -s "$1" "${testfile}" || \
	{ error_return "impossible de créer un lien vers ${testfile}"; }

    ## Les tests sont exécutés par des fonctions auxiliaires selon le
    ## type de fichier de tests.
    case ${extension} in
	R|r)
	    check_criteria_r_script "${testfile}"
	    ;;
	sh)
	    check_criteria_shell_script "${testfile}"
	    ;;
	*)
	    error_return "type de fichier de tests non supporté"
	    ;;
    esac
    
    ## Nettoyage
    rm "./${testfile}" || \
	{ error_return "impossible de supprimer ${testfile}"; }
}

###
### check_criteria_r_script <testfile>
###
##
##  Vérifier la validité des tests contenus dans le fichier de script
##  R <testfile> à l'aide de la fonction 'run_test_file' du paquetage
##  tinytest. Le fichier <testfile> doit donc être compatible avec
##  cette fonction.
##
##  SORTIE STANDARD
##
##  Nombre de tests réussis et nombre de tests exécutés, dans l'ordre,
##  ou "0 0" si l'exécution des tests a échoué.
##
##  ERREUR STANDARD
##
##  Erreur standard du processus R.
##
check_criteria_r_script ()
{
    ## Exécution des tests dans R.
    ##
    ## L'erreur standard du processus R est (temporairement) conservée
    ## dans une variable; la sortie standard est laissée à l'erreur
    ## standard. (https://stackoverflow.com/a/13806684)
    ##
    ## Lorsqu'au moins un test est effectué, le résultat de
    ## l'expression 'summary(run_test_file(...))' est un tableau de 3
    ## colonnes: le nombre de tests effectués ("Results"); le nombre
    ## de tests échoués ("fails"); le nombre de tests réussis
    ## ("passes"). Nous voulons seulement les résultats totaux à la
    ## dernière ligne ("Totals").
    ##
    ## Lorsqu'il n'y a aucun test 'run_test_file' fonctionne
    ## correctement, mais 'summary' sur l'objet créé plante. Il faut
    ## traiter ce cas à part pour retourner "0 0".
    { local msg=$(R --no-restore --no-save --quiet --no-echo 2>&1 1>&3- <<EOF
library("tinytest") 
res <- run_test_file("$1", verbose = 0)
if (length(res)) cat(summary(res)["Total", c("passes", "Results")], fill = TRUE) \
else { message("aucun test exécuté"); cat("0 0", fill = TRUE) }
EOF
) ; } 3>&1

    ## S'il y a des messages d'erreur et que R a été exécuté sous
    ## Windows (au moins jusqu'à la version 10; identifié ici par
    ## ${OSTYPE} = "msys"), il faut convertir le codage des messages
    ## de CP1252 vers UTF-8. Il faut aussi supprimer les retours de
    ## chariot (\r) en fin de ligne.
    [ "${msg:+x}" ] && printf "%s\n" "${msg}" | if [ "${OSTYPE}" = "msys" ]
    then
	iconv -f CP1252 -t utf-8 | tr -d '\r'
    else
	cat -
    fi >&2
}

###
### check_criteria_shell_script <filename>
###
##
##  Vérifier la validité des tests contenus dans le fichier de script
##  Bash <filename>.
##
##  SORTIE STANDARD
##
##  Nombre de tests réussis et nombre de tests exécutés, dans l'ordre,
##  ou "0 0" si l'exécution des tests a échoué.
##
##  ERREUR STANDARD
##
##  Erreur standard du script de tests.
##
check_criteria_shell_script ()
{
    ## Exécution des tests par le shell.
    ##
    ## L'erreur standard du shell est (temporairement) conservée
    ## dans une variable; la sortie standard est laissée à l'erreur
    ## standard. (https://stackoverflow.com/a/13806684)
    { local msg=$(. "./$1" 2>&1 1>&3-) ;} 3>&1

    ## Afficher les messages d'erreur (s'il y en a) à l'erreur
    ## standard.
    [ "${msg:+x}" ] && printf "%s\n" "${msg}" >&2
}
