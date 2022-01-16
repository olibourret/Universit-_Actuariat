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

## Interface
ui <- fluidPage(

    ## Titre
    titlePanel("Exercice sur les contrôles d'entrée"),

    ## Barre latérale avec les contrôles
    sidebarLayout(
        sidebarPanel(
            sliderInput("lambda", "Paramètre de Poisson",
                        value = 2, min = 0, max = 20, step = 0.5)
        ),

        mainPanel(
            textOutput("value_lambda")
        )
    )
)

## Serveur
server <- function(input, output) {
    output$value_lambda <- renderText({
        paste("Valeur du paramètre de Poisson:", input$lambda)
    })
}

## Application
shinyApp(ui = ui, server = server)
