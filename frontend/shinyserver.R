

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
                      verbatimTextOutput("txtout")
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
  output$txtout <- renderText({
    "just some text"
  })
}

shinyApp(ui, server)
