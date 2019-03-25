library(shiny)
library(DT)
library(ggplot2)
library(dplyr)

server <- function(input, output)
{
  # ------------- Import du fichier de données après appui sur le bouton de téléchargement - pas encore fonctionnel   
  
  # push <- reactive(req(input$fichier_data))
  prod_shem <- reactive({read.csv2(input$fichier_data$datapath)})

  # ------------- Affichage du header et du tail du fichier importé dans l'onglet Import des données 
  
  output$apercu_debut <- renderText(
    {
      req(input$fichier_data)
      "Aperçu début :"
    }
  )
  
  output$table_output_head <- renderTable(
    {
      req(input$fichier_data)
      head(prod_shem())
    }
  )
  
  output$apercu_fin <- renderText(
    {
      req(input$fichier_data)
      "Aperçu fin :"
    }
  )
  
  output$table_output_tail <- renderTable(
    {
      req(input$fichier_data)
      tail(prod_shem())
    }
  )
  
  
  # -------------- Affichage de la datatable dans l'onglet Tableau des données 
  
  output$datatable_output <- DT::renderDataTable(DT::datatable(
    {
      req(input$fichier_data)
      prod_shem <- read.csv2(input$fichier_data$datapath)
      
      # Ca marche pas, je sais pas pourquoi --------------
      # prod_filter_periode <- prod_shem() %>% 
      #   filter(dates >= input$debut_fin[1] & dates <= input$debut_fin[2])
      # ---------------------------------------------------
      
      prod_filter_periode <- prod_shem %>% 
        filter(dates >= input$debut_fin[1] & dates <= input$debut_fin[2])
    },
    options = list(pageLength = 366)
  )
  )
    }