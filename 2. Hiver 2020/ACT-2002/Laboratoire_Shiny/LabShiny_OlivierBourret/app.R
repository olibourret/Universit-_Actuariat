### Laboratoire Shiny
### Olivier Bourret
### 111 005 475

library(shiny)

### Cette application permet d'observer que les N échantillons de taille n d'une distribution de
### moyenne mu et de variance sigma^2, la moyenne échantillonnale tend vers une Normale de 
### moyenne mu et de variance sigma^2.



## Interface
ui <- fluidPage(

    ## Titre
    titlePanel("Distribution de la moyenne"),

    withMathJax(),

    helpText("Par le Théorème central limite, la distribution de la moyenne \\(\\bar{X}\\) tend vers une
              $$N(\\mu, \\sigma^2/n).$$"),

    ## Barre latérale avec les contrôles
    sidebarLayout(
        sidebarPanel(
            radioButtons("nb.sim", "Nombre de simulations",
                         choices = c("1000" = 1000,
                                     "10000" = 10000,
                                     "1e+05" = 1E05)),
            numericInput("mu", label = "Moyenne de la distribution", value = 0),
            sliderInput("sigma", "Écart-type de la distribution",
                        value = 1, min = 0, max = 10, step = 0.1)
        ),

        ## Graphique et résultats en format texte
        mainPanel(
            textOutput("Moyenne"),
            textOutput("Variance"),
            plotOutput(outputId = "dataPlot")
        )
    )
)

## Serveur
server <- function(input, output) {
    
    ## Simulation des données
    data <- reactive({
        replicate(input$nb.sim, mean(rnorm(100, input$mu, input$sigma)))
    })
    
    ## Calcul et écriture de la Moyenne
    output$Moyenne <- renderText({
        paste("Moyenne de l'estimateur:", format(mean(data()), digits = 4))
    })

    ## Calcul et écriture de la Variance
    output$Variance <- renderText({
        paste("Variance de l'estimateur:", format(var(data()), digits = 4))
    })
    
    ## Création du graphique
    output$dataPlot <- renderPlot({

        hist(data(), col = "white", xlab = "data()", ylab = "Frequency", main = "Histogram of data()")
    })

}

## Application
shinyApp(ui = ui, server = server)
