
library(tidyverse)
library(stringr)
library(quanteda)
library(stm)

options(encoding = "UTF-8")

pensum <- STV4214B %>%
  filter(type == "pensum") %>%
  mutate(text = str_replace(text, "\\s+", ""))

avsnitt <- pensum %>%
  mutate(avsnitt = str_split(text, "n\r\n")) %>%
  select(-text) %>%
  unnest(avsnitt) %>%
  mutate(avsnitt = str_squish(avsnitt)) %>%
  rename(text = avsnitt) %>%
  mutate(strlength = str_length(text)) %>%
  #filter(strlength >= 100) %>%
  #select(-strlength) %>%
  na.omit()

corpus <- corpus(avsnitt)
docvars(corpus, "tekster") <- avsnitt$text

# save(corpus, file = "./backend/avsnitt.rda")

load("./backend/avsnitt.rda")

test_dfm <- dfm(corpus,
                tolower = TRUE,
                remove_numbers = TRUE,
                remove_punct = TRUE, 
                remove_symbols = TRUE,
                remove_url = TRUE, 
                verbose = TRUE,
                remove = stopwords("en"))

rownames(test_dfm) <- avsnitt$doc_id

save(test_dfm, file = "./backend/dfm.rda")

load("./backend/dfm.rda")


test_dfm_trim <- dfm_trim(test_dfm,
                          min_docfreq = 0.001,
                          max_docfreq = 0.999,
                          docfreq_type = "prop",
                          verbose = TRUE)

docs <- convert(Corptrim, to = "stm") # Henter ut dfm til rart stm-objekt for å finne ut hvilke dokumenter den kaster ut

test_stm <- stm(documents = docs$documents,
                vocab = docs$vocab,
                seed = 9021,
                K = 10,
                data = docs$meta, 
                max.em.its = 5, 
                init.type = "LDA")

# save(test_stm, file = "./test_stm.rda")


#### HENT UT TOPPLADENDE TEKSTER ####

load("~/Prosjekter/Ideathon2020/pensor/backend/TP2forsok36.rda")
load("~/Prosjekter/Ideathon2020/pensor/backend/g1.rda")

df <- as_tibble(TP2forsok36$theta) # Henter ut hvor mye hver tekst scorer på topicene

topptekster <- df %>%
  mutate(id = rownames(g$meta$docid)) %>%
  mutate(tekst = g$meta$tekster) %>%
  gather(colnames(.[, (1:36)]), # All columns except the first two, which are now decision id and text.
         key = emne, value = score) %>%
  group_by(emne) %>%
  arrange(desc(score)) %>%
  top_n(10)

toppavsnitt <- topptekster %>%
  filter(emne %in% c("V9", # Climate club (spørsmål 5)
                     "V3", # Parisavtalen (spørsmål 6) 
                     "V20")) %>% # Om normer (spørsmål 7) 
  ungroup() %>%
  mutate(spm = ifelse(emne == "V9", "Spørsmål 5", # Climate club
                      ifelse(emne == "V3", "Spørsmål 6", # Parisavtalen
                             ifelse(emne == "V20", "Spørsmål 7", # Normer
                                    NA)))) %>%
  mutate(tekst = str_to_sentence(tekst),
         tekst = str_remove_all(tekst, "p "),
         tekst = str_remove_all(tekst, "P "))
  

save(toppavsnitt, file = "./backend/toppavsnitt.rda")


save(testdata, file = "./testdata.rda")
jsonlite::write_json(testdata, path = "./testdata_json.json")

