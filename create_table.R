# Création d'une table factice 
library(lubridate)
library(dplyr)
library(DT)

dates <- seq(as.Date("2012/01/01"), as.Date("2019/01/01"), "day")
periode <- length(dates)
year <- lubridate::year(dates)
month <- lubridate::month(dates)
week <- lubridate::week(dates)
artouste <- runif(periode, min = 0, max = 24)
artouste_lac <- runif(periode, min = 0, max = 2)
bious <- runif(periode, min = 0, max = 14)
fabreges <- runif(periode, min = 0, max = 10)
miegebat <- runif(periode, min = 0, max = 75)
hourat <- runif(periode, min = 0, max = 40)
geteu <- runif(periode, min = 0, max = 6)
castet <- runif(periode, min = 0, max = 3)
mareges <- runif(periode, min = 0, max = 120)
st_pierre <- runif(periode, min = 0, max = 130)
coindre <- runif(periode, min = 0, max = 36)

# prod_shem = c(artouste_lac, artouste, bious, fabreges, miegebat, hourat, geteu, castet, mareges, st_pierre, coindre)
# head(prod_shem)

df <- data.frame(dates, year, month, week, artouste_lac, artouste, bious, fabreges, miegebat, hourat, geteu, castet, mareges, st_pierre, coindre)
head(df)

head(df)
setwd("C:/Users/Corentin/Documents/R/Shiny/Shiny premiers pas")
write.table(df, file = "prod_shem_bidon.csv", sep = ";")

datatable(df)
