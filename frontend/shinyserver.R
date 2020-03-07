library(shiny)
library(tidyverse)

ui <- navbarPage("Pensor",
  navbarMenu("=",
             tabPanel("Home",
                      splitLayout(cellWidths = c("80%", "20%"), 
                      textInput("search", NULL, width = "100%"),
                      actionButton("clicksearch", "SEARCH", width = "100%")),
                      verbatimTextOutput("search")
                      ),
            tabPanel("Upload",
                     fileInput("file", "Last opp pensum",
                               multiple = FALSE,
                               accept = c("text/pdf",
                                          #"text/comma-separated-values,text/plain",
                                          ".pdf")
                               )
                     ),
            tabPanel("About",
                     helpText("Velg eksamen her."),
                     verticalLayout(
                       actionButton("fag1", label = "Eksamen 1", width = "100%"),
                       actionButton("fag1", label = "Eksamen 2", width = "100%"),
                       actionButton("fag1", label = "Eksamen 3", width = "100%"),
                       actionButton("fag1", label = "Eksamen 4", width = "100%"),
                       actionButton("fag1", label = "Eksamen 5", width = "100%")
                     )
                     ),
            tabPanel("Help", 
                     helpText("Velg oppgave her"),
                     verticalLayout(
                       actionButton("fag1", label = "Eksamensoppgave 1", width = "100%"),
                       actionButton("fag1", label = "Eksamensoppgave 2", width = "100%"),
                       actionButton("fag1", label = "Eksamensoppgave 3", width = "100%"),
                       actionButton("fag1", label = "Eksamensoppgave 4", width = "100%"),
                       actionButton("fag1", label = "Eksamensoppgave 5", width = "100%")
                     )
                     ),
            tabPanel("Update", 
                     h2("Pensumutdrag"),
                     p(textOutput("spilltekst")),
                     actionButton("nestetekst", label = "Next", width = "100%")
                     )
            ),
  id = "navigating",
  theme = "appstyle.css"
  )

server <- function(input, output, session) {
  
  # Når knappen klikkes
  observeEvent(input$clicksearch, {
    #updateTextInput(session, "search", NULL, value="")
    updateNavbarPage(session, "navigating", selected = "About")
    
  })
  
  # Mulig måte å fake søking på?
  output$search <- renderText({
    if(input$search == ""){
    }else if(input$search != "STV4214B"){
      paste0(input$search, "...")
    }else if(input$search == "STV4214B"){
      "> STV4214B"
    }
  })
  
  observeEvent(input$nestetekst, {
    mytext <- sample(c("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", "When an unknown printer took a galley of type and scrambled it to make a type specimen book.", "It has survived not only five centuries."), 1)
    output$spilltekst <- renderText(mytext)
  })
  
  
}

shinyApp(ui, server)

#STV4214B
#PCOS4022
#PSY2503
