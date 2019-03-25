library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Hello Shiny !"),
  navbarPage(title = "Onglets",
             tabPanel("Import des données",
                      sidebarLayout(
                        sidebarPanel(title = "Titre du panel",
                                     fileInput(inputId = "fichier_data",
                                               label = "Charger la table de données",
                                               multiple = FALSE,
                                               accept = c("text/csv",
                                                          "text/comma-separated-values,text/plain",
                                                          ".csv")
                                     )
                        ),          
                        
                        mainPanel("Se rendre dans l'onglet Tableau des données pour la visualisation complète",
                                  br(),
                                  br(),
                                  textOutput("apercu_debut"),
                                  br(),
                             tableOutput("table_output_head"),
                             br(),
                             br(),
                             textOutput("apercu_fin"),
                             br(),
                             tableOutput("table_output_tail")
                        )
                      )
             ),
             tabPanel("Tableau des données",
                      sidebarLayout(
                        sidebarPanel(title = "Options de filtrage",
                                     dateRangeInput(inputId = "debut_fin",
                                                    label = "Période",
                                                    start = "2018-01-01",
                                                    end = "2019-01-01",
                                                    min = "2012-01-01",
                                                    max = "2019-03-22")), 
                        mainPanel("Tableau des productions",
                          DT::dataTableOutput("datatable_output")
                        )
                      )
             ),
             tabPanel("Graphiques")
  )
)
