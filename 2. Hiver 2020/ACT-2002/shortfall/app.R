### Emacs: -*- coding: utf-8; fill-column: 62; comment-column: 27; -*-
##
## Copyright (C) 2018 Vincent Goulet
##
## Ce fichier fait partie du projet «Rapports dynamiques avec Shiny»
## http://github.com/vigou3/laboratoire-shiny
##
## Cette création est mise à disposition selon le contrat
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## http://creativecommons.org/licenses/by-sa/4.0/

library(shiny)
library(actuar)

### Cette application simule un échantillon aléatoire d'une Poisson
### composée avec sévérité gamma, calcule l'expected shortfall
### empirique de l'échantillon et trace un graphique de l'aire
### au-dessus de la fonction de répartition empirique correspondant à
### l'expected shortfall.
###
### L'utilisateur peut ajuster les paramètres de la Poisson composée,
### la taille de l'échantillon et le niveau de la Value at Risk.

## Interface
ui <- fluidPage(

    ## Titre
    titlePanel("Expected Shortfall empirique"),

    withMathJax(),

    helpText("La mesure de risque Expected Shortfall est équivalente à la prime stop-loss
              évaluée à la Value at Risk:
              $$\\begin{align}
                    \\text{ES}_\\alpha(S)
                        &= E[(S - \\text{VaR}_\\alpha(S))_+] \\\\
                        &= \\int_{\\text{VaR}_\\alpha(S)}^\\infty
                             (x - \\text{VaR}_\\alpha(S)) f_S(x) dx \\\\
                        &= \\int_{\\text{VaR}_\\alpha(S)}^\\infty
                             (1 - F_S(x)) dx.
                 \\end{align}$$"),

    ## Barre latérale avec les contrôles
    sidebarLayout(
        sidebarPanel(
            h4("Modèle de simulation"),
            helpText("$$S \\sim \\text{Poisson composée}(\\lambda, G)$$"),
            helpText("\\(G\\) est la fonction de répartition d'une loi Gamma(2, 0,002)."),
            helpText("Il est possible de remplacer \\(G\\) par une loi Pareto(2, 1000)."),
            sliderInput("lambda", "Paramètre de Poisson",
                        value = 2, min = 0, max = 20, step = 0.1),
            selectInput("nb.sim", "Taille de l'échantillon",
                        choices = c("Choisir une valeur" = "",
                                    "20" = 20,
                                    "100" = 100,
                                    "1 000" = 1000,
                                    "10 000" = 10000,
                                    "100 000" = 100000),
                        selected = 1000),
            checkboxInput("pareto", "Remplacer la loi gamma par une Pareto"),
            radioButtons("alpha", "Niveau de la VaR",
                         choices = c("0,9" = 0.9,
                                     "0,95" = 0.95,
                                     "0,99" = 0.99))
        ),

        ## Graphique et résultats en format texte
        mainPanel(
            h2("Représentation graphique"),
            plotOutput("zePlot"),
            textOutput("VaR"),
            textOutput("ES")
        )
    )
)

## Serveur
server <- function(input, output) {

    ## Simulation des données
    data <- reactive({
        if (input$pareto)
            rcomppois(input$nb.sim, input$lambda, rpareto(2, 1000))
        else
            rcomppois(input$nb.sim, input$lambda, rgamma(2, 0.002))
    })

    ## Calcul de la VaR pour l'échantillon
    sample_VaR <- reactive({
        quantile(data(), as.numeric(input$alpha), type = 1)
    })

    ## Création du graphique
    output$zePlot <- renderPlot({
        Fn <- ecdf(data())

        k <- knots(Fn)
        VaR <- sample_VaR()
        xx <- rep(c(VaR, k[k > VaR]), each = 2)

        plot(Fn, verticals = TRUE, do.points = FALSE,
             main = "Fonction de répartition empirique")
        axis(side = 1, at = VaR, labels = "VaR")
        polygon(xx, c(1, Fn(head(xx, -1))), col = "tan4")
        lines(c(VaR, VaR), c(0, Fn(VaR)), lty = 2, col = "lightgray")
    })

    ## Affichage de la valeur de la VaR
    output$VaR <- renderText({
        paste("Valeur de la VaR:",
              format(sample_VaR(), digits = 2))
    })

    ## Affichage de la valeur de l'expected shortfall
    output$ES <- renderText({
        x <- data()
        VaR <- sample_VaR()
        paste("Expected Shortfall empirique:",
              format(mean(x[x > VaR]) - VaR, digits = 2))
    })
}

## Application
shinyApp(ui = ui, server = server)
