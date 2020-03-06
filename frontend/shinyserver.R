

library(shiny)
library(tidyverse)

#getOption(shiny.port = "128.39.248.79")

ui <- fluidPage(
  
  titlePanel("Pensor"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Velg pensum",
                multiple = FALSE,
                accept = c("text/pdf",
                           #"text/comma-separated-values,text/plain",
                           ".pdf"))
    ),
  mainPanel("Her skal det skje ting.")
  )
)

server <- function(input, output) {
  
}

shinyApp(ui, server)
