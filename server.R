library(shiny)
library(DT)
library(ggplot2)
library(dplyr)

server <- function(input, output)
{
  
  # ----------------- Preparation des colonnes et de leurs attributs
  
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
  
  # ------------- Import du fichier de donnees apres appui sur le bouton de telechargement   
  
  prod_shem <- reactive({
    
    # ----------------- Import des donnees de prod --- pas de dplyr à cause du colnames que je sais pas faire
    
    prod_shem_import <- read.csv2(input$fichier_data$datapath)
    colnames(prod_shem_import) <- noms_colonnes 
    prod_shem_import[, liste_usines] = apply(prod_shem_import[, liste_usines], 2, as.numeric)
    prod_shem_import = mutate(prod_shem_import, Dates = as.POSIXct(Dates, format = "%d/%m/%Y %H:%M")) #%>% #Formatage des dates

    return(prod_shem_import)
  })
  
  # ------------- Affichage du header et du tail du fichier importe dans l'onglet Import des donnees
  
  output$dim_table <- renderText(
    {
      req(input$fichier_data)
      paste("Vous avez importe un tableau de ", dim(prod_shem())[1], "lignes et", dim(prod_shem())[2], "colonnes.") 
    }
  )
  
  output$apercu_debut <- renderText(
    {
      req(input$fichier_data)
      "Apercu debut :"
    }
  )
  
  output$table_output_head <- DT::renderDataTable(DT::datatable(
    {
      req(input$fichier_data)
      head(prod_shem())
    }
  ))
  
  output$apercu_fin <- renderText(
    {
      req(input$fichier_data)
      "Apercu fin :"
    }
  )
  
  output$table_output_tail <- DT::renderDataTable(DT::datatable(
    {
      req(input$fichier_data)
      tail(prod_shem())
    }
  ))
  
  
  # -------------- Affichage de la datatable de prod 
  
  output$datatable_output_prod <- DT::renderDataTable(DT::datatable(
    {
      req(input$fichier_data)
      prod_shem_prod <- prod_shem()
      
      # -------------- Selection des variables à afficher 
      
      selec_gpmt <- c(input$selec_prix, input$selec_gpmt)
      var_selec <- c(colnames(df_attributs)[1], "Granularite") #On sélectionne au moins la date et la granularite si elle existe
      for(nom_colonne in noms_colonnes) {
        if(df_attributs["noms_gpmt", nom_colonne] %in% selec_gpmt) {var_selec <- c(var_selec, nom_colonne)}
      }
      
      # -------------- Selection de la granularite
      
      granu <- input$granu
      f_granu <- function(x, granularity) {
        switch(granularity,
               "Annee" = lubridate::year(x),
               "Mois" = lubridate::month(x),
               "Semaine" = lubridate::week(x),
               "Jour" = lubridate::yday(x)
        )
      }

      # Affichage du tableau avec ou sans filtre granuralite
      # Somme ou moyenne selon si on calcule en energie ou puissance
      
      ifelse(input$puissance_ou_energie == "puissance", f_calcul <- mean, f_calcul <- sum)
      
      if(granu != "Heure") {     #avec filtre granuralite
        prod_shem_prod %>% 
          filter(Dates >= as.POSIXct(input$debut_fin[1]) & Dates <= as.POSIXct(input$debut_fin[2])) %>%
          group_by(Annee = lubridate::year(Dates), Granularite = f_granu(Dates, granu)) %>%
          summarise_at(liste_usines, f_calcul) %>%
          select(one_of(var_selec))
      }
      else {                     # sans filtre granuralite
        prod_shem_prod %>% 
          filter(Dates >= as.POSIXct(input$debut_fin[1]) & Dates <= as.POSIXct(input$debut_fin[2])) %>%
          select(one_of(var_selec))
      }
      
    },
    options = list(pageLength = 24)
  )
  )
  
  
  
  
  
  
  
  # -------------- Affichage de la datatable de prod 
  
  output$datatable_output_valo <- DT::renderDataTable(DT::datatable(
    {
      # ---------------
      req(input$fichier_data)
      prod_shem_valo <- prod_shem()
      
      # -------------- Calcul des valos horaires
      
      for(nom_col in liste_usines){
        tarif = df_attributs["noms_tarifs", nom_col]
        prod_shem_valo[nom_col] <- prod_shem_valo[nom_col] * prod_shem_valo[tarif]
      }
      
      # -------------- Selection des variables à afficher 
      
      selec_gpmt <- c(input$selec_prix, input$selec_gpmt)
      var_selec <- c(colnames(df_attributs)[1], "Granularite") #On sélectionne au moins la date et la granularite si elle existe
      for(nom_colonne in noms_colonnes) {
        if(df_attributs["noms_gpmt", nom_colonne] %in% selec_gpmt) {var_selec <- c(var_selec, nom_colonne)}
      }
      
      # -------------- Selection de la granularite
      
      granu <- input$granu
      f_granu <- function(x, granularity) {
        switch(granularity,
               "Annee" = lubridate::year(x),
               "Mois" = lubridate::month(x),
               "Semaine" = lubridate::week(x),
               "Jour" = lubridate::yday(x)
        )
      }

      # Affichage du tableau 
      
      if(granu != "Heure") {     #avec filtre granuralite
        prod_shem_valo %>% 
          filter(Dates >= as.POSIXct(input$debut_fin[1]) & Dates <= as.POSIXct(input$debut_fin[2])) %>%
          group_by(Annee = lubridate::year(Dates), Granularite = f_granu(Dates, granu)) %>%
          summarise_at(liste_usines, sum) %>%
          select(one_of(var_selec))
      }
      else {                     # sans filtre granuralite
        prod_shem_valo %>% 
          filter(Dates >= as.POSIXct(input$debut_fin[1]) & Dates <= as.POSIXct(input$debut_fin[2])) %>%
          select(one_of(var_selec))
      }
      
    },
    options = list(pageLength = 24)
  )
  )
}