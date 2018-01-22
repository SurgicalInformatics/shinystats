# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/
rm(list=ls())

library(shiny)
library(tidyverse)
library(scales)
library(ggbeeswarm)
library(broom)
library(pwr)

ggplot <- function(...) ggplot2::ggplot(...) + 
  scale_fill_brewer(palette="Paired") + 
  scale_colour_brewer(palette="Paired") +
  theme_bw()+
  theme(legend.position='top', legend.title=element_blank())


shinyServer(function(input, output) {

  #t-test -------------
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
  
  
  # histogram
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
      # stat_summary(fun.data = mean_se, geom = "errorbar",
      #              colour='orange', width = 0.1,
      #              fun.args = list(mult = 1.96),
      #              size = 1) +
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
  
  #chi-squared ------------   
  create_mydata_chisq = reactive({
    
    input$resample
    ncol = 20
    true_prob = 0.5
    sample_n = input$sample_n
    sex_vector = c(rep('Blue', true_prob*ncol*ncol), rep('Green', (1-true_prob)*ncol*ncol))
    sample_vector = c(rep('Sampled', sample_n), rep('Not sampled', (ncol*ncol-sample_n)))
    
    mydata = data_frame(index = 1:(ncol*ncol),
                        y = rep(1:ncol, ncol),
                        sex = sex_vector,
                        sampled = sample(sample_vector)) %>% 
      mutate(x = ceiling(index/ncol))
    
    mydata
    
    
  })
  
  output$onesample <- renderPlot({
    
    mydata = create_mydata_chisq()
    true_prob = 0.5
    label_data = mydata %>% 
      count(sex, sampled) %>% 
      filter(sampled=='Sampled') %>% 
      mutate(percentage = 100*n/input$sample_n) %>% 
      mutate(label_formatted = paste0(n, ' (', round(percentage, 0), '%) ', sex))
    
    
    
    mydata %>% 
      ggplot(aes(x = x, y = y, fill = sex, colour = sampled, alpha=sampled, shape=sampled, size=sampled)) +
      geom_point(stroke = 2) +
      scale_color_manual(values = c('white', 'black'), guide = FALSE) +
      scale_fill_manual(values = c('#1f78b4', '#33a02c'), guide = FALSE) +
      scale_alpha_manual(values = c(0.4, 1), guide = FALSE)+
      scale_shape_manual(values = c(22, 21), guide = FALSE)+
      scale_size_manual(values = c(8, 5), guide = FALSE) +
      theme_void() +
      labs(subtitle = paste0("General population: ", true_prob*100, '% Blue, ', (1-true_prob)*100, '% Green'), 
           title = paste0('Your sample: ', label_data$label_formatted %>% paste0(collapse=', '))) +
      theme(plot.title = element_text(size=20),
            plot.subtitle = element_text(size=15))
    
    
  }, height = 500)
  
  output$barplot <- renderPlot({
    
    mydata = create_mydata_chisq()
    
    mydata %>%
      filter(sampled=='Sampled') %>% 
      count(sex, sampled) %>% 
      ungroup() %>% 
      mutate(percentage = 100*n/sum(n),
             percentage_label = round(percentage, 0) %>% paste0('%')) %>% 
      ggplot(aes(x = 'Your sample', y = n, fill=sex))+
      scale_y_continuous(expand = c(0,0))+
      geom_bar(position='stack', stat='identity', alpha=0.6) +
      scale_fill_manual(values = c('#1f78b4', '#33a02c'), guide = FALSE) +
      coord_flip() +
      theme_classic()+
      theme(axis.ticks.y = element_blank(),
            axis.text.y =  element_blank(),
            axis.text.x = element_text(size=15),
            axis.title.y = element_blank(),
            axis.title.x = element_text(size=15),
            plot.margin = unit(c(0,2,2,2), 'lines'))+
      ylab('50%')+
      geom_hline(yintercept=input$sample_n/2, colour='black') #+
      #geom_text(aes(label=percentage_label, y=.$n[2]), #.$n[2]) yeah this is a terrbile hack, even tomorrow me will not know what this is
      #          colour='black',
      #          size=10, hjust=c(0,1)) 
    
    
  }, height = 100)
  
  output$pvalue = renderText({
    
    mydata = create_mydata_chisq()
    counts = mydata %>% count(sex, sampled) %>% filter(sampled=='Sampled')
    
    paste0('p-value = ',
           broom::tidy(chisq.test(counts$n, p=c(0.5, 0.5)))$p.value %>% 
             round(3) %>% 
             formatC(3, format='f')
    )
    
  })

  
  #power ---------
  
  output$powerplot <- renderPlot({
    
    input$resample2
    
    number = input$number2
    standard_deviation = input$standard_deviation2
    effect_size = input$effect_size2
    
    
    otter = data.frame(
      name = 'Harry Otter',
      temperature = rnorm(number, mean = 37.2+effect_size, sd = standard_deviation)
    )
    
    
    otter_stats = otter %>% 
      do(tidy(t.test(.$temperature, mu = 37.2)))
    
    confmax = otter_stats$conf.high
    
    if (otter_stats$p.value < 0.001){
      p_value = 'p-value < 0.001 '
    } else{
      p_value = paste0('p-value = ', round(otter_stats$p.value, 3) %>% formatC(3, format='f'))
    }
    
    
    plot = otter %>% 
      ggplot(aes(x = 'Otter')) +
      #geom_quasirandom(aes(y = temperature), size=2, alpha = 0.1, colour = 'black', width = 0.2) +
      coord_flip() +
      theme_classic() +
      geom_hline(yintercept = 37.2,
                 colour = '#a6cee3', size=1.5) +
      annotate('text', x = 'Otter', y = 37.2,
               label = 'Reference',
               hjust = 0, vjust = -5,
               colour = 'black') +
      theme(axis.text.y = element_blank(),
            axis.title.y = element_blank(),
            axis.line.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text.x = element_text(size=14),
            axis.title.x = element_text(size=16),
            plot.title = element_text(size = 18)) +
      ylab('Body temperature; CI - confidence interval') +
      geom_errorbar(data = otter_stats, 
                    aes(ymin = conf.low, ymax = conf.high,
                        x = 'Otter'),
                    width = 0.05, colour = '#1f78b4', size = 1.5) +
      geom_point(data = otter_stats, aes(y = estimate), shape = '|', size = 4, colour = '#1f78b4') +
      annotate('text', x = 'Otter', y = confmax,
               label = 'Your sample',
               hjust = 0, vjust = 3,
               colour = 'black') +
      annotate('text', x = 'Otter', y = confmax,
               label = '95% CI of your mean',
               hjust = -0.05, vjust = 0.3,
               colour = '#1f78b4') +
      ylim(35,41.5) +
      ggtitle(paste(p_value , ' (One-sample t-test)'))
    
    
    if (input$jitter2){
      plot = plot + geom_quasirandom(aes(y = temperature), size=2, alpha = 0.1, colour = 'black', width = 0.2)
    }
    
    plot
    
  }, height=300)
  
  output$your_power <- renderText({
    
    calc_power = pwr.t.test(n = input$number2, d = input$effect_size2/input$standard_deviation2, sig.level = 0.05, type = c("one.sample"))$power
    calc_power = (100*calc_power) %>% round(0)
    
    power_text = paste0('With ', input$number2, ' samples (and a standard deviation of ', input$standard_deviation2,
                        ') you\'ll have a ', calc_power,
                        '% chance to detect a statistically signifant difference if the true difference between your population and the refererence is ',
                        input$effect_size2, ' degrees.')
    
    power_text


  })
  
  
  # power end -----------
})







