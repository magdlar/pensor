
library(tidyverse)
library(readtext)
library(stringr)

options(encoding = "UTF-8")


#### STV4214B ####
pensum_STV4214B <- list.files("C:\\Users\\solsh\\OneDrive\\Documents\\Prosjekter\\Ideathon2020\\STV4214B\\Pensum\\",
                              full.names = TRUE)

pensum_STV4214B <- readtext(pensum_STV4214B) %>%
  mutate(type = "pensum")

eksamen_STV4214B <- list.files("C:\\Users\\solsh\\OneDrive\\Documents\\Prosjekter\\Ideathon2020\\STV4214B\\Eksamen",
                               full.names = TRUE)

eksamen_STV4214B <- readtext(eksamen_STV4214B) %>%
  mutate(type = "eksamen")

sensorveiledning_STV4214B <- list.files("C:\\Users\\solsh\\OneDrive\\Documents\\Prosjekter\\Ideathon2020\\STV4214B\\Sensorveiledning",
                                        full.names = TRUE)

sensorveiledning_STV4214B <- readtext(sensorveiledning_STV4214B) %>%
  mutate(type = "sensorveiledning")

STV4214B <- bind_rows(pensum_STV4214B, eksamen_STV4214B, sensorveiledning_STV4214B)

save(STV4214B, file = "./STV4214B.rda")
