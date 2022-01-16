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

NOTEPROMPT="    "
WARNINGPROMPT="  > "
ERRORPROMPT="  ! "

###
### validate_no_uncommitted
###
##
##  Valider qu'il n'y a pas de changements non archivés dans le dépôt
##  Git courant.
##
validate_no_uncommitted ()
{
    print_msg "  vérification de changements non indexés... "
    if check_uncommitted
    then
        print_msg "ERREUR\n"
        prepend "${ERRORPROMPT}" <<EOF
archiver avec 'git commit' avant de valider le dépôt
EOF
	return 1
    fi
    print_msg "ok\n"
}

###
### validate_no_unpushed
###
##
##  Valider qu'il n'y a pas des archives non publiées sur 'origin'
##  dans le dépôt Git courant.
##
validate_no_unpushed ()
{
    print_msg "  vérification d'archives non publiées... "
    if check_unpushed
    then
        print_msg "ERREUR\n"
        prepend "${ERRORPROMPT}" <<EOF
exécuter 'git push' avant de valider le dépôt
EOF
	return 1
    fi
    print_msg "ok\n"
}

###
### validate_valid_main <name>
###
##
##  Valider que <name> est un nom de branche principale valide.
##
##  Les noms valides sont 'main' et 'master'.
##
validate_valid_main ()
{
    [ $# -ne 1 ] && return 1
    local name="$1"

    print_msg "  vérification du nom de la branche principale... ${name}... "
    if [ "${name}" != "main" ] && [ "${name}" != "master" ]
    then
        print_msg "ERREUR\n"
        prepend "${ERRORPROMPT}" <<EOF
définir une branche principale 'main' ou 'master'
EOF
	return 1
    fi
    print_msg "ok\n"
}

###
### validate_on_main <branch>
###
##
##  Valider que le script est exécuté depuis la branche principale
##  <branch> du dépôt Git courant.
##
validate_on_main ()
{
    [ $# -ne 1 ] && return 1
    local branch="$1"
    
    print_msg "  vérification que la branche courante est ${branch}... "
    if ! check_current_branch "${branch}"
    then
        print_msg "ERREUR\n"
        prepend "${ERRORPROMPT}" <<EOF
exécuter 'git checkout ${branch}' avant de valider le dépôt
EOF
	return 1
    fi
    print_msg "ok\n"
}

###
### validate_repos_name <pattern>
###
##
##  Valider que le nom du dépôt Git courant sur 'origin' après le
##  premier symbole '_' correspond au motif <pattern>.
##
validate_repos_name ()
{
    [ $# -ne 1 ] && return 1
    local pat="$1"

    print_msg "  vérification du nom du dépôt... "
    if ! check_repos_name "${pat}"
    then
        print_msg "... ERREUR\n"
	prepend "${ERRORPROMPT}" <<EOF
le nom ne correspond pas au motif '${pat}'
EOF
        return 1
    fi
    print_msg "... ok\n"
}

###
### validate_repos_laden
###
##
##  Valider que le dépôt Git courant contient des données.
##
validate_repos_laden ()
{
    print_msg "  vérification que le dépôt contient des données... "
    if check_repos_empty
    then
        print_msg "ERREUR\n"
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_contrib <pattern>
###
##
##  Valider -- dresser, en fait -- la liste des contributeurs au
##  projet en excluant ceux correspondant au motif <pattern>.
##
validate_contrib ()
{
    [ $# -ne 1 ] && return 1
    local pat="$1"	
    local contrib=$(list_contrib | grep -v -E "${pat}")
    
    print_msg "  vérification des contributeurs dans le dépôt... "
    if [ "${contrib}" ]
    then
	print_msg "NOTE\n"
        prepend "${NOTEPROMPT}" <<EOF
${contrib}
EOF
    else
	print_msg "AVERTISSEMENT\n"
	prepend "${WARNINGPROMPT}" <<EOF
aucun auteur détecté 
exclusions: ${pat}
EOF
    fi
}

###
### validate_commits <n>
###
##
##  Valider que le dépôt Git courant compte au moins <n> archives.
##
validate_commits ()
{
    [ $# -ne 1 ] && return 1
    local min="$1"
    local ncommits=$(check_commits)

    print_msg "  vérification du nombre d'archives... ${ncommits}... "
    if [ "${ncommits}" -lt "${min}" ]
    then
        print_msg "AVERTISSEMENT\n"
        prepend "${WARNINGPROMPT}" <<EOF
nombre minimal d'archives exigé: ${min}
EOF
	return 1
    fi
    print_msg "ok\n"
}

###
### validate_tag_exists <name>
###
##
##  Valider que l'étiquette <name> existe sur 'origin'.
##
validate_tag_exists ()
{
    [ $# -ne 1 ] && return 1
    local name="$1"

    print_msg "  vérification que l'étiquette '${name}' existe... "
    if ! check_tag_exists "${name}"
    then
        print_msg "ERREUR\n"
        prepend "${ERRORPROMPT}" <<EOF
publier l'étiquette sur origin avec 'git push --tags'
validation effectuée sur la branche courante
EOF
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_branch_exists <branch>
###
##
##  Valider que le dépôt Git courant contient une branche <branch>.
##
validate_branch_exists ()
{
    [ $# -ne 1 ] && return 1
    local branch="$1"

    print_msg "  vérification que la branche '${branch}' existe... "
    if ! check_branch_exists "${branch}"
    then
        print_msg "ERREUR\n"
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_branch_other_than_exists <branch>
###
##
##  Valider que le dépôt Git courant au moins une branch autre que
##  <branch>.
##
validate_branch_other_than_exists ()
{
    [ $# -ne 1 ] && return 1
    local branch="$1"

    print_msg "  vérification qu'au moins une branche autre que '${branch}' existe... "
    if ! check_branch_other_than_exists "${branch}"
    then
        print_msg "ERREUR\n"
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_files_in_branch <branch> <filename> [...]
###
##
##  Valider que la branche <branch> du dépôt Git courant contient
##  uniquement les fichiers <filename> [...].
##
validate_files_in_branch ()
{
    [ $# -lt 3 ] && return 1
    local branch="$1"; shift
    local inrepo=

    print_msg "  vérification du contenu de la branche '${branch}'... "
    if ! inrepo=$(check_files_in_branch "${branch}" "$@")
    then
        print_msg "ERREUR\n"
        prepend "${ERRORPROMPT}" <<EOF
cible: $@
EOF
	prepend "${ERRORPROMPT}" <<EOF
dépôt: ${inrepo}
EOF
        return 1
    fi
    print_msg "ok\n"
}


###
### validate_merged_in_branch <branch> <n>
###
##
##  Valider que la branche <branch> contient au moins <n> fusions.
##
validate_merged_in_branch ()
{
    [ $# -ne 2 ] && return 1
    local branch="$1"; shift
    local min="$1"
    local nmerged=$(check_merged_in_branch "${branch}")

    print_msg "  vérification du nombre de fusions dans '${branch}'... ${nmerged}... "
    if [ "${nmerged}" -lt "${min}" ]
    then
        print_msg "AVERTISSEMENT\n"
        prepend "${WARNINGPROMPT}" <<EOF
nombre minimal de fusions exigé: ${min}
EOF
	return 1
    fi
    print_msg "ok\n"
}
    

###
### validate_file_exists <filename>
###
##
##  Valider que le fichier <filename> existe.
##
##  La méthode utilisée est plus lente que '[ -f <filename> ]', mais
##  elle permet de s'assurer que la casse est respectée sur un système
##  de fichier non sensible à la casse (comme macOS).
##
validate_file_exists ()
{
    [ $# -ne 1 ] && return 1
    local filename="$1"

    print_msg "  vérification que ${filename} existe... "
    if [ -z "$(find . -maxdepth 1 -name "${filename}")" ]
    then
        print_msg "ERREUR\n"
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_file_laden <filename>
###
##
##  Valider que le fichier <filename> contient des données.
##
validate_file_laden ()
{
    [ $# -ne 1 ] && return 1
    local filename="$1"

    print_msg "  vérification que ${filename} contient des données... "
    if [ ! -s "${filename}" ]
    then
        print_msg "ERREUR\n"
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_dir_laden <dirname>
###
##
##  Valider que le répertoire <dirname> contient des fichiers.
##
validate_dir_laden ()
{
    [ $# -ne 1 ] && return 1
    local dirname="$1"

    print_msg "  vérification que ${dirname} contient des données... "
    if [ -z "$(ls -A ${dirname})" ]
    then
        print_msg "ERREUR\n"
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_file_encoding <filename>
###
##
##  Valider que le fichier <filename> est codé en UTF-8 ou 
##  en ASCII pur.
##
validate_file_encoding ()
{
    [ $# -ne 1 ] && return 1
    local filename="$1"

    print_msg "  vérification du codage de ${filename}... "
    if ! check_file_encoding "${filename}"
    then
        print_msg "... AVERTISSEMENT\n"
	prepend "${WARNINGPROMPT}" <<EOF
les types de codage permis sont 'ascii' et 'utf-8'
EOF
        return 1
    fi
    print_msg "... ok\n"
}

###
### validate_portable <filename>
###
##
##  Valider que le fichier de script R <filename> est portable.
##
validate_portable ()
{
    [ $# -ne 1 ] && return 1
    local filename="$1"
    local msg=

    print_msg "  vérification que ${filename} est portable... "
    if ! msg=$(check_portable "${filename}" 2>&1)
    then
        print_msg "AVERTISSEMENT\n"
	prepend "${WARNINGPROMPT}" <<EOF
${msg}
EOF
        return 1
    fi
    print_msg "ok\n"
}

###
### validate_source <filename>
###
##
##  Valider le contenu du fichier <filename>.
##
validate_source ()
{
    [ $# -ne 1 ] && return 1
    local filename="$1"
    local msg=

    print_msg "  vérification du contenu de ${filename}... "
    if ! msg=$(check_source "${filename}" 2>&1)
    then
        print_msg "ERREUR\n"
	prepend "${ERRORPROMPT}" <<EOF
${msg}
EOF
        return 1
    fi
    print_msg "ok\n"
}
