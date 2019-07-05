# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/

library(shiny)
library(shinythemes)


fluidPage(theme = shinytheme("cosmo"),
          
          
          # Application title
          titlePanel('ShinyStats: experiment and interact with statistical tests'),
          #shinythemes::themeSelector(),
          
          
          # Sidebar with a slider input for number of bins
          tabsetPanel(type = "tabs", selected = 'Power',
                      #t-test --------------
                      tabPanel('t-test/ANOVA',
                               
                               sidebarLayout(
                                 source(here::here("ui", "01_ttest.R"))$value,
                                 # Show a plot of the generated distribution
                                 mainPanel(
                                   fluidRow(column(6,
                                   plotOutput("boxplot")),
                                   column(6,
                                   plotOutput("boxplot3"))),
                                   br(),
                                   plotOutput("histogram", width = "100%", height = "300px")
                                 )
                                 
                               )), # end t-test -------------
                      #Chi-squared ----------------
                      tabPanel('Chi-squared',
                               sidebarLayout(
                                 source(here::here("ui", "02_chisquared.R"))$value,
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
                                 source(here::here("ui", "03_power.R"))$value,
                                 # Show a plot of the generated distribution
                                 mainPanel(
                                   plotOutput("powerplot")
                                 )
                               )),
                      # end Power-------
                      # Linear Regression --------------
                      tabPanel('Linear regression',
                               shinyLP::iframe(width = "100%", height = "900", "https://argoshare.is.ed.ac.uk/multi_regression/")
                               ),
                      # end Linear regression-------
                      # Bayes --------------
                      tabPanel('Bayesian statistics',
                               shinyLP::iframe(width = "100%", height = "950", "https://argoshare.is.ed.ac.uk/bayesian_two_proportions/")
                      )
                      # end Linear regression-------
                      # 
                      
          ),
          fluidRow(
            column(12,
                   h4(strong("About ShinyStats:")),
                   p("“ShinyStats” is a series of web-based interactive applications (Apps) created using the R statistical programming language and an extension called Shiny.
                      Students are given already visualised sample data to interact with;
                      for example, they can manipulate the number of observations.
                      Each time an observation is altered, the application displays the p-value (an indicator of statistical significance).
                      This level of experimentation gives the students a more thorough understanding of statistical concepts,
                      benefitting not only their own research and analysis but also the ability to understand the results quoted in published medical literature."),
                   h4(strong("ShinyStats is developed by")),
                   a(href="http://surgicalinformatics.org/about-us/", "Riinu Ots"),
                   h4(strong("with ongoing support from:")),
                   a(href="http://www.ed.ac.uk/institute-academic-development/learning-teaching/funding/funding", img(src="ptas_logo.jpeg", width = 270), target="_blank"),
                   a(href="https://www.edinburghsurgeryonline.com/", img(src="eso.png", width = 150), target="_blank"),
                   img(src='surginf_logo.png', width = 180)
            )),
          fluidRow(column(12,
                          h4(strong("ShinyStats is developed using:")),
                          a(href="https://shiny.rstudio.com/", img(src="shiny_logo.png", width = 150), target="_blank")
          )
          )
)

