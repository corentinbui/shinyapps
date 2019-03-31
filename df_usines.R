library(dplyr)

# prod_shem <- read.csv2("C:/Users/coren/Documents/R/ShinyApps/Shiny_premiers_pas/prod SHEM 4 vallees 2017 2018.csv")



noms_usines_ossau <- c("Artouste Lac", "Artouste Usine", "Bious", "Pont de Camps", "Miegebat", "Hourat", "Geteu", "Castet", "Fabreges")
noms_usines_valentin <- c("Eaux bonnes", "Assouste", "Espalungue")
noms_usines_mareges <- c("Mareges", "Saint Pierre", "Coindre")
noms_usines_louron <- c("Lassoula", "Clarabide", "Lapes", "Pont de Prat", "Aube", "Pont d'Estagnou")
noms_usines_eget <- c("Eget", "Oule")
liste_gpmt <- c(rep("Ossau", 9), rep("Valentin", 3), rep("Mareges", 3), rep("Louron", 6), rep("Eget", 2))
liste_tarifs <- c(rep("spot", 6), "OA4C", rep("OA5C", 5), rep("spot", 6), "OA4C", "OA5C", "OA1C", "spot", "OA5C")

noms_colonnes <- c("Dates", "Prix spot", "Prix OA2C", "Prix OA4C", "Prix OA5C", noms_usines_ossau, noms_usines_valentin, noms_usines_mareges, noms_usines_louron, noms_usines_eget)
noms_col_bidons <- rep("bidon", 28)
noms_gpmt <- c(NA, "prix_spot", rep("prix_OA", 3), liste_gpmt)
noms_tarifs <- c(NA, "prix_spot", "prix_OA2C", "prix_OA4C", "prix_OA5C", liste_tarifs)

df_attributs <- data.frame(noms_gpmt, noms_tarifs )
df_attributs <- t(df_attributs)
colnames(df_attributs) <- noms_colonnes

selec_gpmt <- c("Ossau", "Valentin", "Louron", "prix_spot")
var_selec <- c()
for(nom_colonne in noms_colonnes) {
  if(df_attributs["noms_gpmt", nom_colonne] %in% selec_gpmt) {var_selec <- c(var_selec, nom_colonne)}
}
var_selec
# View(prod_shem)


