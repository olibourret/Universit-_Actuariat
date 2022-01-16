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
### error_exit <string>
###
##
##  Afficher le message d'erreur <string> et quitter un script.
##
error_exit ()
{
    printf >&2 "%s: %b\n" "${SCRIPTNAME}" "${1:-"erreur inconnue"}"
    exit 1
}

###
### error_return <string>
###
##
##  Afficher le message d'erreur <string> et quitter une fonction.
##
error_return ()
{
    printf >&2 "%b\n" "${1:-"erreur inconnue"}"
    return 1
}
