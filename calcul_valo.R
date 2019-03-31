library(dplyr)
library(purrr)



prod_shem <- read.csv2("C:/Users/coren/Documents/R/ShinyApps/Shiny_premiers_pas/prod SHEM 4 vallees 2017 2018.csv")
prod_shem_valo <- prod_shem

noms_usines_ossau <- c("Artouste_Lac", "Artouste_Usine", "Bious", "Pont_de_Camps", "Miegebat", "Hourat", "Geteu", "Castet", "Fabreges")
noms_usines_valentin <- c("Eaux_bonnes", "Assouste", "Espalungue")
noms_usines_mareges <- c("Mareges", "Saint_Pierre", "Coindre")
noms_usines_louron <- c("Lassoula", "Clarabide", "Lapes", "Pont_de_Prat", "Aube", "Pont_d_Estagnou")
noms_usines_eget <- c("Eget", "Oule")
liste_usines <- c(noms_usines_ossau, noms_usines_valentin, noms_usines_mareges, noms_usines_louron, noms_usines_eget)
liste_gpmt <- c(rep("Ossau", 9), rep("Valentin", 3), rep("Mareges", 3), rep("Louron", 6), rep("Eget", 2))
liste_tarifs <- c(rep("Prix_spot", 6), "Prix_OA4C", rep("Prix_OA5C", 5), rep("Prix_spot", 6), "Prix_OA4C", "Prix_OA5C", "Prix_OA1C", "Prix_spot", "Prix_OA5C")
liste_prix <- c("Prix_spot", "Prix_OA1C", "Prix_OA2C", "Prix_OA4C", "Prix_OA5C")

noms_colonnes <- c("Dates", liste_prix, liste_usines)
noms_gpmt <- c(NA, "prix_spot", rep("prix_OA", 4), liste_gpmt)
noms_tarifs <- c(rep(NA, 6), liste_tarifs)

df_attributs <- data.frame(noms_gpmt, noms_tarifs)
df_attributs <- t(df_attributs)
colnames(df_attributs) <- noms_colonnes

# for(nom_col in liste_usines){
#   tarif = df_attributs["noms_tarifs", nom_col]
#   prod_shem_valo[nom_col] <- prod_shem_valo[nom_col] * prod_shem_valo[tarif]
# }

#Test somme/moyenne selon les colonnes

lst(liste_prix, liste_usines) %>% 
  map2(
    lst(
      rep(sum = sum, length(liste_prix)),
      rep(mean = mean, length(liste_usines))
      ),
    ~prod_shem_valo %>% summarise_at(c(liste_prix, liste_usines))
  ) %>% 
  reduce(inner_join)

