library(shiny)
library(tidyverse)
library(CodeClanData)
library(shinythemes)

ui <- fluidPage(
    
  theme = shinytheme("flatly"),
  
  titlePanel(tags$h1("Five Country Medal Comparison")),
  
  tabsetPanel(
  
        tabPanel( "Choose your inputs",
      
      fluidRow(
      
        column(4,
          
          radioButtons(
                    inputId = "season",
                    label = "Summer or Winter Olympics?",
                    choices = c(
                                "Summer",
                                "Winter"
                                )
                    ),
          ),
        
        column(8,
        
            radioButtons(
                        inputId = "medal",
                        label = "Medal type",
                        choices = c(
                                    "Gold",
                                    "Silver",
                                    "Bronze"
                                    )
                        )
            ),
        ),
      ),
    
    tabPanel(
      "Medals",
  
          plotOutput("medal_plot")
      )
    )
  )



server <- function(input, output) {
  
    output$medal_plot <- renderPlot({
    
        olympics_overall_medals %>%
      
            filter(team %in% c(
                                "United States",
                                "Soviet Union",
                                "Germany",
                                "Italy",
                                "Great Britain"
                                )
                   ) %>%
            
      filter(medal == input$medal) %>%
      
            filter(season == input$season) %>%
      
    ggplot() +
      aes(
        x = team,
        y = count,
        fill = count
      ) +
      geom_col(fill = case_when(
                              input$medal == "Gold" ~ "gold2",
                              input$medal == "Silver" ~ "grey50",
                              input$medal == "Bronze" ~ "orange4"
                              )
               )
  })
}

shinyApp(
  ui = ui,
  server = server
)
