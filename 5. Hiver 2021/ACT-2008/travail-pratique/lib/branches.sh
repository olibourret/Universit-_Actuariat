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
### get_main_name
###
##
##  Récupère le nom de la branche principale du dépôt sur 'origin'.
##
get_main_name ()
{
    git remote show origin | grep "HEAD branch" | sed 's/.*: //'
}

###
### check_current_branch <branch>
###
##
##  Vérifier que la branche courante du dépôt Git est <branch>.
##
check_current_branch ()
{
    test "$(git branch --show-current)" = "$1"
}

###
### check_branch_exists <pattern>
###
##
##  Vérifier que le dépôt Git courant contient une branche sur
##  'origin' dont le nom correspond au motif (d'expressions régulières
##  étendues) <pattern>.
##
check_branch_exists ()
{
    git branch -r | grep -v HEAD | grep -E -q "$1"
}

###
### check_branch_other_than_exists <pattern>
###
##
##  Vérifier que le dépôt Git courant contient au moins une branche
##  sur 'origin' dont le nom correspond à autre chose que le motif
##  (d'expressions régulières étendues) <pattern>.
##
check_branch_other_than_exists ()
{
    git branch -r | grep -v HEAD | grep -v -E -q "$1"
}

###
### check_files_in_branch <branch> <filename> [...]
###
##
##  Vérifier que la branche <branch> du dépôt Git courant contient
##  uniquement les fichiers <filename> [...].
##
##  SORTIE STANDARD
##
##  Noms des fichiers de la branche séparés par des espaces.
##
check_files_in_branch ()
{
    local branch=$1; shift
    local files=$(tr ' ' '\n' <<EOF | sort
$@
EOF
)
    local inrepo=$(git ls-tree --name-only -r "${branch}" | tr -d ' ')

    printf "%s" "$(tr '\n' ' ' <<EOF
${inrepo}
EOF
)"
    
    [ $(comm -23 <(printf "%s" "${inrepo}") <(printf "%s" "${files}") | head -c1 | wc -c) -eq 0 ]
}

###
### check_merged_in_branch <branch>
###
##
##  Vérifier que la branche <branch> contient des fusions.
##
##  SORTIE STANDARD
##
##  Nombre de fusions
##
check_merged_in_branch ()
{
    printf "%d" "$(git log --merges --first-parent "$1" --oneline | wc -l)"
}
