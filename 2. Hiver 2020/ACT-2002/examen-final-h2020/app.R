## EXAMEN FINAL H-2020 - APPLICATION SHINY À COMPLÉTER
##
## Copyright (C) 2020 Vincent Goulet
##
## Ce fichier fait partie du cours
## ACT-2002 Méthodes numériques en actuariat
##
## Cette création est mise à disposition sous licence
## Attribution-Partage dans les mêmes conditions 4.0 International de
## Creative Commons. https://creativecommons.org/licenses/by-sa/4.0/

###
### Chargement des paquetages essentiels
###
library(shiny)
library(actuar)

###
### nrmult(FUN, gradiant, start, TOL = 1E-6,
###        maxiter = 100, echo = FALSE, ...)
###
##  Calcule la solution d'un système d'équations non linéaires
##  f(x) = 0 par la méthode de Newton-Raphson multivariée.
##
##  Arguments
##
##  FUN: fonction pour calculer le vecteur f(x).
##  gradiant: fonction pour calculer les valeurs de la
##    matrice des dérivées.
##  start: vecteur de valeurs de départ.
##  TOL: niveau de tolérance pour déterminer la convergence.
##  maxiter: nombre maximal d'itérations.
##  echo: valeur booléenne; si TRUE, les valeurs
##    successives des solutions sont affichées à l'écran.
##  '...': arguments additionnels à passer aux fonctions
##    FUN et gradiant.
##
##  Valeur
##
##  Liste de deux éléments nommés:
##
##    roots: le vecteur des racines;
##    nb.iter: le nombre d'itérations.
##
nrmult <- function(FUN, gradiant, start, TOL = 1E-6,
                    maxiter = 100, echo = FALSE, ...)
{
    if (echo)
        expr <- expression(print(start <- start - adjust))
    else
        expr <- expression(start <- start - adjust)

    i <- 0

    repeat
    {
        adjust <- solve(gradiant(start, ...), FUN(start, ...))

        if (max(abs(adjust)) < TOL)
            break

        if (maxiter < (i <- i + 1))
            stop("Maximum number of iterations reached
                  without convergence")

        eval(expr)
    }
    list(roots = start - adjust, nb.iter = i)
}

###
### Code de l'application
###

## Interface
ui <- fluidPage(

    ## Titre
    titlePanel("Ajustement de modèles par le maximum de vraisemblance"),

    ## Barre latérale avec les contrôles
    sidebarLayout(
        sidebarPanel(
            fileInput("datafile", h4("Choisir un fichier de données"),
                accept = c("text/plain", ".data", ".dat"),
                buttonLabel = "Choisir",
                placeholder = "Aucun fichier sélectionné",
                multiple = FALSE),
            selectInput("dist", h4("Choisir un modèle"),
                        choices = c("Pareto" = "pareto",
                                    "Gamma" = "gamma"),
                        multiple = FALSE)
        ),

        ## Graphique et résultats en format texte
        mainPanel(
            plotOutput("fitPlot"),
            textOutput("valuePars")
        )
    )
)

## Serveur
server <- function(input, output)
{

    ## Importation des données
    data <- reactive({
        inFile <- input$datafile

        if (is.null(inFile))
            return(NULL)

        scan(inFile$datapath)
    })

    ## Calcul des paramètres du modèle obtenus en résolvant le système
    ## d'équations approprié selon la distribution choisie.
    ##
    ## Le résultat de cette fonction réactive doit être un vecteur
    ## nommé (ou étiqueté) de deux éléments contenant les paramètres
    ## de la distribution.
    ##
    ## Les étiquettes sont les noms des paramètres du modèle tels
    ## qu'utilisés dans les fonctions 'd<loi>' de R (par exemple:
    ## "shape" et "rate" pour la distribution gamma).
    param <- reactive({
        m1 <- length(data())^(-1) *sum(data())
        m2 <- length(data())^(-1) * sum(data()^2)
        if(input$dist == "pareto")
        {
            r <- list("shape" = 2 * (m2 - m1^2) /(m2 - 2 * m1^2), "rate" = m1 * m2 /(m2 - 2 * m1^2))
    
           
            
        }
    
        if(input$dist == "gamma")
        {
            
            eshape <- m1^2/(m2 - m1^2)
            erate <- m1/(m2 - m1^2)
            r <- nrmult(FUN = log(dgamma), gradiant = digamma, start = c(eshape, erate), TOL = 1E-6, maxiter = 100, echo = FALSE, data())
            
        }
        
       r
        
    })

    ## Graphique
    output$fitPlot <- renderPlot({
        ## histogramme des données
        hist(data(), prob = TRUE, main = "Histogramme des données")

        ## densité superposée
        if (input$dist == "pareto")
             curve(dpareto(x, param()[1], param()[2]), add = TRUE)
        else if (input$dist == "gamma")
            curve(dgamma(x, param()[1], param()[2]), add = TRUE)
    })

    ## Texte sous le graphique
    output$valuePars <- renderText({
        p <- param()
        paste("Paramètres du modèle: ",
              names(p[1]), " = ", signif(p[1], 6),
              ", ",
              names(p[2]), " = ", signif(p[2], 6),
              sep = "")
    })
}

## Application
shinyApp(ui = ui, server = server)

