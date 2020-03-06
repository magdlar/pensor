

library(shiny)
library(tidyverse)

#getOption(shiny.port = "128.39.248.79")

# ui <- fluidPage(
#   
#   titlePanel("Pensor"),
#   
#   sidebarLayout(
#     sidebarPanel(
#       fileInput("file", "Velg pensum",
#                 multiple = FALSE,
#                 accept = c("text/pdf",
#                            #"text/comma-separated-values,text/plain",
#                            ".pdf"))
#     ),
#   mainPanel("Her skal det skje ting.")
#   )
# )

ui <- navbarPage("Pensor",
  navbarMenu("=",
             tabPanel("Home",
                        textInput("search", NULL),
                        verbatimTextOutput("search")


                      ),
            tabPanel("Upload",
                     fileInput("file", "Last opp pensum",
                               multiple = FALSE,
                               accept = c("text/pdf",
                                          #"text/comma-separated-values,text/plain",
                                          ".pdf")
                               )
                     )
            )
  )
server <- function(input, output) {
  
  # Mulig måte å fake søking på?
  output$search <- renderText({
    if(input$search == ""){
    }else if(input$search != "STV4214B"){
      paste(input$search, "...")
    }else if(input$search == "STV4214B"){
      "> STV4214B"
    }
  })
}

shinyApp(ui, server)

#STV4214B
#PCOS4022
#PSY2503
