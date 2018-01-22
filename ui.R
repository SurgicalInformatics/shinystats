# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/
rm(list=ls())

library(shiny)
library(shinythemes)


shinyUI(fluidPage(theme = shinytheme("cosmo"),
                  
                  
                  # Application title
                  titlePanel('ShinyStats: experiment and interact with statistical tests'),
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
                                                    actionButton("resample2", "Resample")
                                                    ),
                                           fluidRow( 
                                             strong(textOutput('your_power')),
                                             p()
                                           ),
                                           sliderInput("number2",
                                                       "Sample size:",
                                                       min = 5,
                                                       max = 250,
                                                       value = 20,
                                                       step=5),
                                           checkboxInput("jitter2", "Show individual observations", TRUE),
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

                              ),
                  fluidRow(
                    h4(strong("About ShinyStats:")),
                    p("“ShinyStats” is a series of web-based interactive applications (Apps) created using the R statistical programming language and an extension called Shiny.
                      Students are given already visualised sample data to interact with;
                      for example, they can manipulate the number of observations.
                      Each time an observation is altered, the application displays the p-value (an indicator of statistical significance).
                      This level of experimentation gives the students a more thorough understanding of statistical concepts,
                      benefitting not only their own research and analysis but also the ability to understand the results quoted in published medical literature."),
                    h4(strong("ShinyStats is developed by")),
                    a(href="http://www.ed.ac.uk/surgery/staff/surgical-profiles/riinu-ots", "Riinu Ots"),
                    h4(strong("with ongoing support from:")),
                    a(href="http://www.ed.ac.uk/institute-academic-development/learning-teaching/funding/funding", img(src="ptas_logo.jpeg", width = 270), target="_blank"),
                    a(href="http://www.essq.rcsed.ac.uk/", img(src="eso.png", width = 150), target="_blank"),
                    img(src='surginf_logo.png', width = 180)
                  ),
                  fluidRow(
                    h4(strong("ShinyStats is developed with:")),
                    a(href="https://shiny.rstudio.com/", img(src="shiny_logo.png", width = 150), target="_blank")
                  )
                  )
)
