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
### print_msg <string>
###
##
##  Écrire <string> à la sortie standard. Les séquences d'échappement
##  dans <string> sont interprétées.
##
print_msg ()
{
    printf "%b" "$1"
}

###
### print_result <description> <résultat>
###
##
##  Écrire à la sortie standard une chaine de caractères de longueur
##  standardisée avec la <description> d'un critère de correction
##  suivie du <résultat>.
##
print_result ()
{
    ## Bash compte la longueur des chaines de caractères en octets
    ## plutôt qu'en caractères. Ça fait une différence avec les
    ## caractères Unicode. Il faut donc composer les deux colonnes de
    ## texte en ajoutant manuellement le nombre approprié d'espaces.
    ## https://unix.stackexchange.com/a/592479
    local cw=45

    printf "%s%*s%s" "$1" $((cw - ${#1})) "" "$2"
}

###
### prepend <string>
###
##
##  Écrire à la sortie standard le contenu de l'entrée standard avec
##  <string> ajouté au début de chaque ligne.
##
prepend ()
{
    while IFS= read -r line
    do
	print_msg "$1${line}\n"
    done
}
