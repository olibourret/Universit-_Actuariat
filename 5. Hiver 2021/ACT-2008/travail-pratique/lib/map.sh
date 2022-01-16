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
### mkmap <dirname> <conffile>
###
##
##  Créer la carte de correction dans le répertoire <dirname> du
##  système de fichiers à partir des informations du fichier de
##  configuration <conffile>.
##
##  La carte spécifie le matériel à corriger, les critères de
##  correction, les tests à effectuer et les points accordés pour
##  chaque critère.
##
##  Les informations de configuration
##
##  [catégorie]
##    [sujet]
##      clé: valeur
##
##  résultent en un fichier <dirname>/[catégorie]/[clé]/sujet
##  contenant le texte 'valeur'.
##
##  Inspiré de https://stackoverflow.com/a/691023
mkmap ()
{
    [ $# != 2 ] && return 1
    local mapdir="$1"; local conffile="$2"
    local class=
    local indent=

    ## Erreur si aucune catégorie '__global' dans le fichier.
    if ! grep -q "^__global$" "${conffile}"
    then
	error_return "catégorie '__global' manquante dans la configuration"
    fi
    
    grep -v '^#' "${conffile}" | while IFS='' read -r line
    do
	## Pas de texte indenté de ${indent} espaces sur la ligne:
	## remonter d'un niveau dans la classification et enlever un
	## niveau d'indentation.
	while grep -q -v "^${indent}" <<EOF
${line}
EOF
      	do
	    class="${class%/*}"	# supprimer un répertoire
	    indent="${indent%  }" # supprimer deux espaces
	done

	## Les espaces en début de ligne ne sont plus nécessaires dans
	## la suite.
	line="$(printf "%s" "${line}" | xargs)"

	## Analyse d'une ligne: action différente selon que la ligne
	## contient une paire clé-valeur (identifiée par la présence
	## du caractère ':') ou une nouvelle sous-catégorie.
	if grep -q ":" <<EOF
${line}
EOF
	then
	    ## Écrire la valeur dans un fichier nommé d'après la clé.
	    mapput "${mapdir}/${class}" "${line%%:*}" "${line#*: }"
	else
	    ## Ajouter un niveau de classification et deux espaces à
	    ## l'indentation.
	    class="${class}/${line}"
	    indent="${indent}  "
	fi
    done
}

###
### mapput <classification> <key> <value>
###
##
##  Inscrire dans une <classification> la valeur <value> d'une clé
##  <key>.
##
mapput ()
{
    [ $# != 3 ] && return 1
    local class=${1%/}; local key=$2; local value=$3
    
    [ -d "${class}" ] || mkdir -p "${class}"
    printf > "${class}/${key}" "%b" "${value}"
}

###
### mapget <classification> <key>
###
##
##  Extraire de la <classification> la valeur de la clé <key>.
##
mapget ()
{
    [ $# != 2 ] && return 1
    local class=${1%/}; local key=$2
    
    [ -f "${class}/${key}" ] && cat "${class}/${key}"
}
