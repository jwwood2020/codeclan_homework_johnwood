
# Load libraries --------------------------------

library(tidyverse)
library(shiny)
library(shinythemes)
library(CodeClanData)
library(DT)



ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  titlePanel("Games - data visualisation"),
  tabsetPanel(
    
    #--------------------------------------------
    # Tab plotting data by Year
    # Showing this allows the user to see how these variables change over time
    # This can give an insight into how the games market has developed.
    tabPanel("by Year",
             radioButtons("year_variable",
                          "What do you want to see?",
                          choices = c("Total Sales",
                                      "Average Critic Score",
                                      "Average User Score"
                          ),
                          inline = TRUE
             ),
             
             plotOutput("year_plot")
    ),
    #--------------------------------------------
    
    #--------------------------------------------
    # Tab plotting data by Platform
    # This visualisation is similar to the above, but allows the user to choose
    # which platform to look at.
    tabPanel("by Platform",
             
             selectInput("platform_choice",
                         "Which platform?",
                         choices = sort(unique(game_sales$platform))
             ),
             fluidRow(
               column(4,
                      plotOutput("platform_sales")
               ),
               column(4,
                      plotOutput("platform_critic")
               ),
               column(4,
                      plotOutput("platform_user")
               )
             )
    ),
    #--------------------------------------------
    
    #--------------------------------------------
    # Tab with table of all game data
    # Allows user to investigate the full data
    tabPanel(
      "Game data",
      DT::dataTableOutput("games_table")
    )
    #--------------------------------------------
  )
)

server <- function(input, output, session) {

  #----------------------------------------------
  # Output plots by year
  # Note that one record with a outlier release year of 1988 has been filtered
  game_years <- game_sales %>% 
    filter(year_of_release != 1988) %>% 
    group_by(year_of_release) %>% 
    summarise(total_sales = sum(sales),
              average_critic_score = mean(critic_score),
              average_user_score = mean(user_score)
              ) 
  
  output$year_plot <- renderPlot({
    
    if (input$year_variable == "Total Sales"){
      
      plot <-  ggplot(game_years) +
        aes(x = year_of_release,
            y = total_sales) +
        geom_col() +
        labs(x = "\nYear of Release",
             y = "Total Sales") +
        theme_minimal()
    }
    
    if (input$year_variable == "Average Critic Score"){
      
      plot <- ggplot(game_years) +
        aes(x = year_of_release,
            y = average_critic_score) +
        geom_line() +
        scale_y_continuous(limits = c(1,100)) +
        labs(x = "\nYear of Release",
             y = "Average Critic Score") +
        theme_minimal()
    }
    
    if (input$year_variable == "Average User Score"){
      
      plot <-  ggplot(game_years) +
        aes(x = year_of_release,
            y = average_user_score) +
        geom_line() +
        scale_y_continuous(limits = c(1,10)) +
        labs(x = "\nYear of Release",
             y = "Average User Score") +
        theme_minimal()
    }
    
    plot
  })
  #----------------------------------------------
  
  #----------------------------------------------
  # Output plots by platform
  # Note that one record with a outlier release year of 1988 has been filtered
  platform <- reactive(
    game_sales %>% 
    filter(year_of_release != 1988) %>% 
    filter(platform == input$platform_choice) %>% 
    group_by(year_of_release) %>% 
    summarise(total_sales = sum(sales),
              average_critic_score = mean(critic_score),
              average_user_score = mean(user_score)
    )
  )
  
  output$platform_sales <- renderPlot({
    ggplot(platform()) +
        aes(x = year_of_release,
            y = total_sales) +
        geom_col() +
      labs(x = "\nYear of release",
           y = "Total sales") +
      theme_minimal()
  })
    
  output$platform_critic <- renderPlot({    
      ggplot(platform()) +
        aes(x = year_of_release,
            y = average_critic_score) +
        geom_line() +
        scale_y_continuous(limits = c(0,100)) +
      labs(x = "\nYear of Release",
           y = "Average Critic score") +
      theme_minimal()
  })
    
  output$platform_user <- renderPlot({
    ggplot(platform()) +
        aes(x = year_of_release,
            y = average_user_score) +
        geom_line() +
        scale_y_continuous(limits = c(0,10)) +
      labs(x = "\nYear of release",
           y = "Average user score")+
      theme_minimal()
  })
    
  #----------------------------------------------

  #----------------------------------------------
  # Output table of all games data
  # Columns reordered
  output$games_table <- renderDataTable({
    game_sales %>% 
      select(name,
             genre,
             developer,
             publisher,
             platform,
             year_of_release,
             critic_score,
             user_score,
             sales)
  })
  #----------------------------------------------
}

shinyApp(ui, server)
