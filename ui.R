# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/
rm(list=ls())

library(shiny)
library(shinythemes)


shinyUI(fluidPage(theme = shinytheme("superhero"),
  

  # Application title
  titlePanel("Two-sample t-test"),
  #shinythemes::themeSelector(),

  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("number",
                  "Number of obsevrations (sample size per group):",
                  min = 5,
                  max = 250,
                  value = 20,
                  step=5),
      checkboxInput("jitter", h4("Show individual observations"), FALSE),
      sliderInput("standard_deviation",
                  "Variability (standard deviation):",
                  min = 0.1,
                  max = 2.0,
                  value = 0.4,
                  step=0.1),
      sliderInput("effect_size",
                  "Difference between the groups (effect size):",
                  min = 0.1,
                  max = 1.0,
                  value = 0.2,
                  step=0.05),
      p('Mean body temperature of Justin Beaver: 37.2 degrees Celcius'),
      textOutput('mean_otter')
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      #fixedRow(
      #column(4,
             plotOutput("boxplot"),
             br(),
       #      ),
      #column(4,
             plotOutput("histogram")
      #)
      #)
      )
    )
  )
)
