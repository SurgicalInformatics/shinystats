# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/
rm(list=ls())

library(shiny)
library(shinythemes)


shinyUI(fluidPage(theme = shinytheme("cosmo"),
                  
                  
                  # Application title
                  titlePanel('Statistic of the Month'),
                  #shinythemes::themeSelector(),
                  
                  
                  # Sidebar with a slider input for number of bins
                  tabsetPanel(type = "tabs", selected = 'Power',
                              #t-test --------------
                              tabPanel('t-test',
                                       
                                       sidebarLayout(
                                         sidebarPanel(
                                           sliderInput("number",
                                                       "Number of observations (sample size per group):",
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
                                           plotOutput("boxplot"),
                                           br(),
                                           plotOutput("histogram")
                                         )
                                       )), # end t-test -------------
                              #Chi-squared ----------------
                                       tabPanel('Chi-squared',
                                                sidebarLayout(
                                                  sidebarPanel(
                                                    sliderInput("sample_n",
                                                                "Sample size:",
                                                                min = 10,
                                                                max = 200,
                                                                value = 50,
                                                                step = 10),
                                                    actionButton("resample", "Resample"),
                                                    p('                   '),
                                                    h4('Chi-squared test for given probabilities:'),
                                                    p('Is your sample statistically significantly different to the general population?'),
                                                    textOutput('pvalue')
                                                  ),
                                                  
                                                  # Show a plot of the generated distribution
                                                  mainPanel(
                                                    plotOutput("onesample", width = "100%"),
                                                    plotOutput("barplot", width = "100%")
                                                  )
                                                )

                                       ),
                              # end Chi-squared -------
                              #Power --------------
                              tabPanel('Power',
                                       
                                       sidebarLayout(
                                         sidebarPanel(
                                           fluidRow( 
                                             column(3,
                                                    actionButton("resample2", "Resample")),
                                             column(9,
                                                    strong(textOutput('your_power')))
                                           ),
                                           sliderInput("number2",
                                                       "Sample size:",
                                                       min = 5,
                                                       max = 250,
                                                       value = 20,
                                                       step=5),
                                           checkboxInput("jitter2", h4("Show individual observations"), TRUE),
                                           sliderInput("standard_deviation2",
                                                       "Standard deviation:",
                                                       min = 0.1,
                                                       max = 2.0,
                                                       value = 0.4,
                                                       step=0.1),
                                           sliderInput("effect_size2",
                                                       "Effect size:",
                                                       min = 0.1,
                                                       max = 1.0,
                                                       value = 0.2,
                                                       step=0.05)
                                           
                                           
                                         ),
                                         
                                         # Show a plot of the generated distribution
                                         mainPanel(
                                           plotOutput("powerplot")
                                         )
                                       ))
                              # end Power-------
                              # 

                              )
                  )
)
