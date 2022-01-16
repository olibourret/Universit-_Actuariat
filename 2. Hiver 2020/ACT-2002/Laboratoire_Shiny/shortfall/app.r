#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Révision de l'utilisation de Shiny"),
    
    helpText("Afin d'écrire des équations mathématiques en shiny,
             il faut d'abord charger \\(withMathJax()\\) dans
             \\(fluidpage\\)"),
    
    withMathJax(),
    
    helpText(
        "Lorsque cela est fait, on peut écrire des équations
             mathématiques tout en respectant la syntaxe Latex. Il s'agit de
             la syntaxe qui a été vue lors du laboratoire Rmarkdown. Petite exception
             cependant, il faut doubler les \\ à l'intérieur des équations afin
             d'écrire des lettres greques comme \\(\\alpha\\) ou
             \\(\\beta\\) ou bien afin de délimiter les équations.
             On peut également écrire des équations séparées du texte en
             utilisant la commande \\($$ \\quad $$\\). Voici un exemple
             de l'utilisation de cette commande :
             $$
             f_{x_1 x_2}(x_1 x_2) = \\frac{1}{\\Gamma(\\alpha)}
             x_2 ^{\\alpha - 1} e^{-(x_1 + x_2)}, \\quad x_1 > 0, x_2 > 0.
             $$
             Intéressons-nous à présent à un petit exemple qui révise
             les définitions de trace et de déterminant d'une matrice.
             L'application présentée génère, à chaque ouverture, une
             nouvelle matrice composée d'entiers entre 1 et 20 choisis
             aléatoirement et sans remise. On peut, grâce à la barre
             latérale, choisir quelle valeur associée à la matrice on
             désire calculer."
    ),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h5("Calcule de différentes valeurs associées à la matrice
               ci-contre"),
            radioButtons("tr_det", "Valeur que l'on désire calculer :",
                         choices = c("Trace" = TRUE,
                                     "Déterminant" = FALSE))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("Voici la matrice exemple"),
            tableOutput("mat"),
            textOutput("caract")
            
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output){
    
    m <- matrix(c(sample(1:20, 9)), ncol = 3)
    
    data <- reactive({
        
        
        if (input$tr_det == TRUE)
            c <- sum(diag(m))
        
        else
            c <- det(m)
        
    })
    
    output$mat <- renderTable({m})
    
    output$caract <- renderText({
        if (input$tr_det == TRUE)
            paste("Valeur de la trace:", data())
        
        else
            paste("Valeur du déterminant:", data())
        
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
