# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/
rm(list=ls())

library(shiny)
library(ggplot2)
library(dplyr)
library(scales)
ggplot <- function(...) ggplot2::ggplot(...) + 
  scale_fill_brewer(palette="Paired") + 
  scale_colour_brewer(palette="Paired") +
  theme_bw()+
  theme(legend.position='top', legend.title=element_blank())


shinyServer(function(input, output) {

  
  data_reactive         <- reactive({
    
    set.seed(1)
    
    number = input$number
    standard_deviation = input$standard_deviation
    effect_size = input$effect_size
    
    #number = 60
    #standard_deviation = 0.4
    #effect_size = 0.2
    
    set.seed(1)
    beaver = data.frame(
      name = 'Justin Beaver',
      temperature = rnorm(number, mean = 37.2, sd = standard_deviation)
    )
    set.seed(1)
    otter = data.frame(
      name = 'Harry Otter',
      temperature = rnorm(number, mean = 37.2+effect_size, sd = standard_deviation)
    )
    alldata = rbind(beaver, otter)
    #alldata$temperature = round(alldata$temperature, digits=1)
    alldata
    
  })
  
  
  # histogram -----------
  output$histogram <- renderPlot({
    
    
    alldata = data_reactive()
    alldata$temperature = round(alldata$temperature, digits=1)
    
    alldata %>% 
      ggplot() +
      aes(x=temperature, fill=name) +
      geom_bar() +
      #geom_bar(aes(y = ..count../sum(..count..)), position='dodge') +
      #scale_y_continuous(label=percent) +
      labs(y="Number of observations", x='Temperature') +
      facet_wrap(~name)
    


  }, 500)
  
  output$boxplot <- renderPlot({
    
    number = input$number
    standard_deviation = input$standard_deviation
    effect_size = input$effect_size
    
    alldata = data_reactive()
    
    test_result = t.test(temperature~name, data = alldata)
    
    if (test_result$p.value < 0.001){
      p_value = 'p-value < 0.001 '
    } else{
      p_value = paste0('p-value = ', round(test_result$p.value, 3))
    }
    
    
    plot = alldata %>% 
      ggplot() +
      aes(x=name, fill=name, y=temperature) +
      #geom_jitter(width=0.3, alpha=0.5) +
      geom_boxplot(alpha=0.5)+
      labs(y="Temperature", x='') +
      ylim(35,41.5) +
      annotate('text', x='Justin Beaver', y=41.5, label = p_value, size=8, hjust = 0.2)
    
    if (input$jitter){
      plot = plot + geom_jitter(width=0.3, alpha=0.5)
    }
    
    plot
    
  }, 280)
  output$mean_otter <- renderText(
  #mean_beaver = 'Mean body temperature of Justin Beaver: 37.2 degrees Celcius'
  paste0('Mean body temperature of Harry Otter:    ', 37.2+input$effect_size, ' degrees Celcius')
  )
  

})







