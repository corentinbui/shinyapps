library(dplyr)
library(lubridate)
# prod_shem <- read.csv2("C:/Users/coren/Documents/R/ShinyApps/Shiny_premiers_pas/prod SHEM 4 vallees 2017 2018.csv")
prod_shem_granu <- prod_shem %>% 
  mutate(dates = as.POSIXct(dates, format = "%d/%m/%Y %H:%M"))

test <- prod_shem_granu  %>%
  group_by(Annee = lubridate::year(dates)) %>% 
  summarise_all(mean)
