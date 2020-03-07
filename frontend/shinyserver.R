library(shiny)
library(tidyverse)

ui <- navbarPage(title=div(img(src='logo.jpg', height="40px", width="30px"), "ensor"),
  navbarMenu("=",
             tabPanel("Home",
                      splitLayout(cellWidths = c("80%", "20%"), 
                      textInput("search", NULL, width = "100%"),
                      actionButton("clicksearch", "SEARCH", width = "100%")),
                      verbatimTextOutput("search")
                      ),
            tabPanel("Upload",
                     h2("Last opp pensum"),
                     fileInput("file", NULL,
                               multiple = FALSE,
                               accept = c("text/pdf",
                                          #"text/comma-separated-values,text/plain",
                                          ".pdf")
                               )
                     ),
            tabPanel("About",
                     h2("STV4214B"),
                     verticalLayout(
                       actionButton("eks1", label = "Høst 2019", width = "100%"),
                       actionButton("eks1", label = "Vår 2019", width = "100%"),
                       actionButton("eks1", label = "Høst 2018", width = "100%"),
                       actionButton("eks1", label = "Vår 2018", width = "100%"),
                       actionButton("eks1", label = "Høst 2017", width = "100%")
                     )
                     ),
            tabPanel("Help",
                     h2("Eksamensoppgaver"),
                     verticalLayout(
                       actionButton("opp1", label = "1. How might a climate club create a snoball effect?", width = "100%"),
                       actionButton("opp1", label = "2. What are the advantages of choosing a buttom-up design...?", width = "100%"),
                       actionButton("opp1", label = "3. How do multiliteralist and unilateralist views differ?", width = "100%"),
                       actionButton("opp1", label = "4. What are Garrett Hardin's main solutions?", width = "100%"),
                       actionButton("opp1", label = "5. What is the purpose of international environmental agreements?", width = "100%"),
                       br(),
                       plotOutput("wordplot"),
                       br()
                     )
                     ),
            tabPanel("Update", 
                     #h2("Pensumutdrag"),
                     textOutput("spilltekst"),
                     splitLayout(actionButton("tilbake", label = "Back", width = "100%"),
                                 actionButton("nestetekst", label = "Next", width = "100%")),
                     br()
                     )
            ),
  id = "navigating",
  theme = "appstyle.css"
  )

server <- function(input, output, session) {
  
  library(quanteda)
  library(tidytext)
  library(wordcloud)
  
  # Hardkodet som midlertidig workaround
  STV4214B <- readRDS("C:/Users/Magnus/Documents/Programmer/pensor/frontend/www/STV421B.rds")
  
  stoppord <- tibble(word = stopwords("en"))
  
  eksamen <- STV4214B %>%
    filter(doc_id == "Høst 2019.pdf") %>%
    filter(type == "eksamen") %>%
    mutate(text = str_replace(text, "\\s+", "")) %>%
    unnest_tokens(word, text) %>%
    anti_join(stoppord, by = "word") %>%
    count(word, sort = TRUE)
  
  #pal <- brewer.pal(8,"Dark2")
  
  output$wordplot <- renderPlot({
    eksamen %>% 
      with(wordcloud(word, n, 
                     random.order = FALSE, 
                     max.words = 200, 
                     colors=brewer.pal(8,"Dark2")))
  })
  
  # Søkeknapp
  observeEvent(input$clicksearch, {
    updateNavbarPage(session, "navigating", selected = "About")
    
  })
  
  # Velg eksamen knapp
  observeEvent(input$eks1, {
    updateNavbarPage(session, "navigating", selected = "Help")
    
  })
  
  # Velg oppgave knapp
  observeEvent(input$opp1, {
    updateNavbarPage(session, "navigating", selected = "Update")
    
  })
  
  # Tilbakeknapp
  observeEvent(input$tilbake, {
    updateNavbarPage(session, "navigating", selected = "Help")
    
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
  
  # Default tekst til appen, bare så den ikke er helt tom...
  output$spilltekst <- renderText("Trykk 'neste' for å begynne!")
  
  # Hardkodet som short term workaround
  toppavsnitt <- readRDS(file="C:\\Users\\Magnus\\Documents\\Programmer\\pensor\\frontend\\www\\toppavsnitt.rds")
  observeEvent(input$nestetekst, {
    mytext <- toppavsnitt[which(toppavsnitt$emne == "V9"),]$tekst[sample(c(1:nrow(toppavsnitt[which(toppavsnitt$emne == "V9"),])), 1)]
    mytext <- str_trunc(mytext, 600)
    #sample(c("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", "When an unknown printer took a galley of type and scrambled it to make a type specimen book.", "It has survived not only five centuries."), 1)
    output$spilltekst <- renderText(mytext)
  })
  
  
}

shinyApp(ui, server)

#STV4214B
#PCOS4022
#PSY2503
