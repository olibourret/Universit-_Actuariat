### Emacs: -*- coding: utf-8; fill-column: 62; comment-column: 27; -*-
##
## Copyright (C) 2019 Vincent Goulet
##
## Ce fichier fait partie du projet «Rapports dynamiques avec Shiny»
## http://gitlab.com/vigou3/laboratoire-shiny
##
## Cette création est mise à disposition selon le contrat
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## http://creativecommons.org/licenses/by-sa/4.0/

library(shiny)
library(actuar)

## Interface
ui <- fluidPage(

    ## Titre
    titlePanel("Exercice sur le recalcul des valeurs"),

    ## Barre latérale avec les contrôles
    sidebarLayout(
        sidebarPanel(
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
            radioButtons("alpha", "Niveau de la VaR",
                         choices = c("0,9" = 0.9,
                                     "0,95" = 0.95,
                                     "0,99" = 0.99))
        ),

        ## Graphique et résultats en format texte
        mainPanel(
            textOutput("moyenne"),
            textOutput("VaR")
        )
    )
)

## Serveur
server <- function(input, output) {

    ## Simulation des données
    data <- reactive({
        rcomppois(input$nb.sim, input$lambda, rgamma(2, 0.002))
    })

    ## Calcul de la moyenne de l'échantillon
    sample_mean <- reactive({
        mean(data())
    })

    ## Calcul de la VaR pour l'échantillon
    sample_VaR <- reactive({
        quantile(data(), as.numeric(input$alpha), type = 1)
    })

    ## Affichage de la valeur de la moyenne
    output$moyenne <- renderText({
        paste("Moyenne de l'échantillon:",
              format(sample_mean(), digits = 2))
    })

    ## Affichage de la valeur de la VaR
    output$VaR <- renderText({
        paste("Valeur de la VaR:",
              format(sample_VaR(), digits = 2))
    })
}

## Application
shinyApp(ui = ui, server = server)
