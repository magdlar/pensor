                                                                               ########### HACKATHON ODA MARCHAND 
setwd("~/Downloads/pensor")
load("~/Downloads/pensor/backend/avsnitt.rda")


library(knitr)            
library(stringr)         
library(dplyr)          
library(ggplot2)         
library(stm)             
library(png)             
library(grid)             
library(quanteda)       
library(quanteda.corpora) 
library(rjson)
library(readtext)
library(tidytext)
library(quanteda)
library(tidyverse)
library(stm)
library(rsvd)
library(Rtsne)
library(stringr)




# Ferdig corpus "avsnitt" fra Solveig

corpus$documents$texts
docvars(corpus)
summary(corpus)




# TOPIC MODELS

# lage korpus til dfm
StopwordsCorpus <- dfm(corpus,       
                       remove_punct = TRUE,
                       remove_symbols = TRUE, 
                       remove_numbers = TRUE,  
                       remove_twitter = TRUE, 
                       remove_url = TRUE,
                       remove_hyphens = TRUE, 
                       remove_separators = TRUE,tolower = TRUE, 
                       remove = c(stopwords("english"))) 

topfeatures(StopwordsCorpus , 100)  

Corptrim <- dfm_trim(StopwordsCorpus, # Ord skal dukke opp i minst 1 % og maks 99 % av dokumentene.
                     min_termfreq = 0.0009, # Ord som dukker opp veldig sjelden.
                     #min_docfreq = 0.002, # Ord som dukker opp veldig ofte.
                     max_termfreq = 0.015, # fjernes dersom dukker opp i mer enn 50 prosent
                     termfreq_type = "prop") # ??


topfeatures(Corptrim, 100)  #topp!


# veldig sparse # Document-feature matrix of: 20,113 documents, 146 features (98.3% sparse).
quantdfm <- Corptrim [rowSums(Corptrim) > 0, ]
quantdfm


# gjør om til stm
g <- convert(Corptrim, to = "stm") # WM: troppet sykt mange docs

#save(g, file= "~/Documents/HACKATHON/g.rda")
# load("~/Documents/HACKATHON/g.rda")

save(g, file= "~/Downloads/pensor/backend/g1.rda")




### TOPIC MODEL







                                    ############ K-test


set.seed(2020)


k_resultsTP3forsok <- searchK(documents = g$documents, vocab = g$vocab, 
                     max.em.its = 1000,
                     K = c(30, 31,  33,  35, 36, 38), data = g$meta, set.seed(2020)) 


save(k_resultsTP3forsok, file= "~/Downloads/pensor/backend/k_resultsTP3forsok.rda")
load("~/Downloads/pensor/backend/k_resultsTP3forsok.rda")
save.image("~/Downloads/pensor/backend/k_resultsTP3forsokImage.rda") 
           
k_results <- k_resultsTP1forsok
k_results <- k_resultsTP2forsok
k_results <- k_resultsTP3forsok
                
                 

# dev.off()
# install.packages("ggplot2")
# library(ggplot2)


# Another alternative
k_result_plotdata <- data.frame(Exclusivity = k_results$results$exclus,
                                Coherence = k_results$results$semcoh,
                                Heldout = k_results$results$heldout,
                                Residual = k_results$results$residual,
                                K = k_results$results$K)
library(reshape2)
k_result_plotdata <- melt(k_result_plotdata, measure.vars = c("Exclusivity", "Coherence",
                                                              "Heldout", "Residual"))


?melt 
?melt.data.table
load(reshape2)
load(data.table)
library(reshape2)


ggplot(k_result_plotdata, aes(x = K, y = value, color = variable)) + # colour = variable i stedet for metric
  facet_wrap(~variable, scales = "free_y") +
  geom_line(size = 1.5, alpha = 0.7, show.legend = FALSE) + # tok inn 
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(y = NULL, x = "Number of topics")





########### stm #############
####### le TOPIC MODELLING #####



# LDA 

TP4forsok45 <- stm(documents = g$documents,
                  vocab = g$vocab,
                  data = g$meta,
                  K = 45,
                  init.type = "LDA", 
                  max.em.its = 10000,
                  set.seed(2019))  

TP2forsok36 <- TP2forsok
TP3forsok38 <- TP3forsok



# 30 emner
save(TP1forsok, file = "~/Downloads/pensor/backend/TP1forsok.rda")
load("~/Downloads/pensor/backend/TP1forsok.rda")
save.image("~/Downloads/pensor/backend/TP1forsokImage.rda") 
stm <- TP1forsok 



# 36 emner
save(TP2forsok36, file = "~/Downloads/pensor/backend/TP2forsok36.rda")
load("~/Downloads/pensor/backend/TP2forsok36.rda")
save.image("~/Downloads/pensor/backend/TP2forsok36Image.rda")
stm <- TP2forsok36


# 38 emner
save(TP3forsok38, file = "~/Downloads/pensor/backend/TP3forsok38.rda")
load("~/Downloads/pensor/backend/TP3forsok38.rda")
save.image("~/Downloads/pensor/backend/TP3forsok38Image.rda")
stm <- TP3forsok38


#45 emner
save(TP4forsok45, file = "~/Downloads/pensor/backend/TP4forsok45.rda")
load("~/Downloads/pensor/backend/TP4forsok45.rda")
save.image("~/Downloads/pensor/backend/TP4forsok45Image.rda")
stm<- TP4forsok45




plot(stm) # plot 
stm$settings$dim$K # sjekker antall emner

# Topplading med frekvens # FREX
labelTopics(stm, topics=NULL, n=45, frexweight = 0.5 ) # ?  0.5 - kun frekvens? 
terms <- labelTopics(stm, c(1:stm$settings$dim$K))  # Lgger objekt via LabelTopics, med alle temaene
terms

#FREX: topladetermer på emnene, de som har høyest frekvens.  
terms$frex[1:10, ] # head(terms$frex)[1:6, ]   
terms$frex[36, ] ## nummeret er Temaet, emnet, topic-et








# Toppsannsynlighet ord i emnene basert på thetaverdiene
# stm$theta inneholder porporsjoner for hvert dokument de 10 største emnene eller flere 
top_prop <- data.frame(topic = paste0("Topic ", 1:ncol(stm$theta)),        # thetaverdiene 
                       m_prop = apply(stm$theta, 2, mean),                 # thetaverdienes gjennomsnitt
                       top_frex = apply(labelTopics(stm, n = 36)$frex, 1,  # toppfrekvens ordene
                                        function(x) paste(x, collapse = ", ")))

# Ordene i emnene med høyest sannynlighet for forekomst i hvert emne
top_prop$topic <- factor(top_prop$topic, levels = top_prop$topic[order(top_prop$m_prop)])
head(top_prop)
top_prop

# finne tekstene på hvert emne
findThoughts(stm, texts = Corpus$documents$texts, n = 10, topics = 20) # 
findThoughts(stm, texts = g$meta$tekster, n = 5, topics = 20) # 

# Finne tekstene som har høyest sannsynlighet for å lade på dette emnet
top_texts <- findThoughts(stm, g$meta$tekster, topics = 20, n = 1) 
top__texts <- str_sub(g$meta$tekster[top_texts$index$`Topic 20`], 1, 200) 
top__texts

# Bruker kwik for å finne ut mer om dem #нейтральный #нейтраль
kwic(g$meta$tekster, "ес", 70) 













