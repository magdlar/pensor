
#### Wordcloud ####

load("./backend/STV4214B.rda")

stoppord <- tibble(word = stopwords("en"))

eksamen <- STV4214B %>%
  filter(doc_id == "Høst 2019.pdf") %>%
  filter(type == "eksamen") %>%
  mutate(text = str_replace(text, "\\s+", "")) %>%
  unnest_tokens(word, text) %>%
  anti_join(stoppord, by = "word") %>%
  count(word, sort = TRUE)

pal <- brewer.pal(8,"Dark2")

eksamen %>% 
  with(wordcloud(word, n, 
                 random.order = FALSE, 
                 max.words = 200, 
                 colors=brewer.pal(8,"Dark2")))