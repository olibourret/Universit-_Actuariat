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
### count_objects
###
##
##  Compter le nombre d'objets libres (non compressés) dans le dépôt
##  Git courant ou, si cette valeur est nulle, le nombre d'objets
##  compressés.
##
##  SORTIE STANDARD
##
##  Le nombre d'objets.
##
count_objects ()
{
    git count-objects -v | awk 'BEGIN { n = 0 } 
                                /^count/ { if ($2 > 0) { n = $2; exit } } 
                                /^in-pack/ { n = $2 > 0 ? $2 : n } 
                                END { print n }'
}

###
### check_uncommitted
###
##
##  Vérifier qu'il y a des changements non archivés dans le dépôt Git
##  courant.
##
check_uncommitted ()
{
    git status --porcelain | grep -qv '^??'
}

###
### check_unpushed
###
##
##  Vérifier qu'il y a des archives non publiées sur 'origin' dans le
##  dépôt Git courant.
##
check_unpushed ()
{
    local branch=$(git rev-parse --abbrev-ref HEAD)

    [ $(git log origin/"${branch}"..HEAD | head -c1 | wc -c) -ne 0 ]
}

###
### check_repos_name <pattern>
###
##
##  Vérifier que le nom du dépôt Git courant sur 'origin' correspond au
##  motif <pattern>. Tout ce qui précède un symbole "_" dans le nom du
##  dépôt, y compris le symbole, est supprimé avant d'être comparé au
##  motif.
##
##  SORTIE STANDARD
##
##  Nom du dépôt.
##
check_repos_name ()
{
    local fullname=$(basename -s .git $(git config --get remote.origin.url))
    local name=${fullname#*_}

    printf "%s" "${name}"

    grep -Eq "$1" <<EOF
"${name}"
EOF
}

###
### check_repos_empty
###
##
##  Vérifier que le dépôt Git courant est vide.
##
check_repos_empty ()
{
    [ $(count_objects) -eq 0 ]
}

###
### check_commits <n>
###
##
##  Vérifier le nombre d'archives dans le dépôt Git courant.
##
##  SORTIE STANDARD
##
##  Nombre d'archives.
##
check_commits ()
{
    printf "%d" "$(git rev-list --count HEAD)"
}

###
### check_tag_exists <name>
###
##
##  Vérifier que l'étiquette <name> existe sur le serveur.
##
check_tag_exists ()
{
    git ls-remote --tags origin | grep -E -q "$1"
}

###
### checkout_by_date <timestamp>
###
##
##  Extraire la version d'un dépôt antérieure à la date et à l'heure
##  <timestamp>.
##
##  VALEUR
##
##  Résultat de 'git checkout' si le dépôt contient au moins une
##  archive; 2 sinon.
##
checkout_by_date ()
{
    if [ -z "$(git rev-list --all)" ]
    then
        return 2
    fi

    local sha=$(git rev-list -n 1 --before="$1" HEAD | cut -c1-7)
    git checkout "${sha}" >/dev/null 2>&1
}

###
### list_contrib
###
##
##  Affiche la liste des contributeurs dans le dépôt
##
##  VALEUR
##
##  Contributeurs du dépôt à raison d'un par ligne.
##
list_contrib ()
{
    git log --pretty="%an" | sort | uniq
}
