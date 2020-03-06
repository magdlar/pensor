
library(tidyverse)
library(stringr)
library(quanteda)


pensum <- STV4214B %>%
  filter(type == "pensum") %>%
  mutate(text = str_replace(text, "\\s+", ""))

glimpse(avsnitt)

avsnitt <- pensum %>%
  mutate(avsnitt = str_split(text, "\r\n")) %>%
  select(-text) %>%
  unnest(avsnitt) %>%
  rename(text = avsnitt)

test_corpus <- corpus(avsnitt)

test_dfm <- dfm(test_corpus,
                remove_url = TRUE,
                remove_numbers = TRUE,
                remove_punct = TRUE, 
                remove_symbols = TRUE,
                remove_url = TRUE, 
                verbose = TRUE,
                remove = stopwords("en"))

testmodel <- stm(avsnitt,
                 )