#t-test -------------
data_bodytemp <- reactive({
  
  set.seed(1)
  
  number = input$number
  standard_deviation = input$standard_deviation
  effect_size = input$effect_size
  
  # number = 60
  # standard_deviation = 0.4
  # effect_size = 0.2
  
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
  set.seed(1)
  meerkat = data.frame(
    name = 'Jenny Meerkat',
    temperature = rnorm(number, mean = 37.2+2*effect_size, sd = standard_deviation)
  )
  alldata = rbind(beaver, otter, meerkat)
  #alldata$temperature = round(alldata$temperature, digits=1)
  alldata
  
})


# histogram ----------
output$histogram <- renderPlot({
  
  alldata = data_bodytemp()
  alldata$temperature = round(alldata$temperature, digits=1)
  
  avg_temparature = tibble(name = c("Justin Beaver", "Harry Otter", "Jenny Meerkat"),
                           avg_temp = c(37.2, 37.2+input$effect_size, 37.2+2*input$effect_size))
    
    alldata %>% 
    group_by(name) %>% 
    summarise(avg_temp = mean(temperature) %>% round(1))
  
  alldata %>% 
    ggplot() +
    aes(x=temperature, fill=name) +
    geom_bar(width = 0.1, alpha = 0.8) +
    #geom_bar(aes(y = ..count../sum(..count..)), position='dodge') +
    scale_y_continuous(expand = c(0, 0)) +
    labs(y="Number of observations", x='Temperature') +
    facet_wrap(~name) +
    geom_vline(data = avg_temparature, aes(xintercept = avg_temp)) +
    geom_label(data = avg_temparature,
               aes(x = avg_temp, y = input$number/5, label = avg_temp),
               hjust = 1, vjust = 1, show.legend = FALSE, alpha = 0.8)
  
  
  
}, 500)

# boxplot 2 groups --------------
output$boxplot <- renderPlot({
  
  alldata = data_bodytemp() %>% 
    filter(name != "Jenny Meerkat")
  
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
    labs(y="Temperature", x='', title = "t-test") +
    theme(title = element_text(size = 18),
          axis.text.x = element_text(size = 20, colour = "black"),
          legend.text = element_text(size = 12, colour = "black")) +
    ylim(35,41.5) +
    # stat_summary(fun.data = mean_se, geom = "errorbar",
    #              colour='orange', width = 0.1,
    #              fun.args = list(mult = 1.96),
    #              size = 1) +
    annotate('text', x='Harry Otter', y=41.5, label = p_value, size=10, hjust = 0.2) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 10))
  
  if (input$jitter){
    plot = plot + geom_jitter(width=0.3, alpha=0.5) 
  }
  
  plot
  
}, 300)

# boxplot 3 groups --------------
output$boxplot3 <- renderPlot({
  
  alldata = data_bodytemp()
  
  test_result = aov(temperature~name, data = alldata) %>% 
    tidy() %>% 
    filter(term == "name")
  
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
    labs(y="Temperature", x='', title = "ANOVA") +
    theme(title = element_text(size = 18),
          axis.text.x = element_text(size = 16, colour = "black"),
          legend.text = element_text(size = 12, colour = "black")) +
    ylim(35,41.5) +
    # stat_summary(fun.data = mean_se, geom = "errorbar",
    #              colour='orange', width = 0.1,
    #              fun.args = list(mult = 1.96),
    #              size = 1) +
    annotate('text', x='Harry Otter', y=41.5, label = p_value, size=8, hjust = 0.2) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 10))
  
  if (input$jitter){
    plot = plot + geom_jitter(width=0.3, alpha=0.5) 
  }
  
  plot
  
}, 350)


# text labels/sentences ---------------
output$mean_otter <- renderText(
  #mean_beaver = 'Mean body temperature of Justin Beaver: 37.2 degrees Celcius'
  paste0('Mean body temperature of Harry Otter:    ', 37.2+input$effect_size, ' degrees Celcius')
)

output$mean_meerkat <- renderText(
  #mean_beaver = 'Mean body temperature of Justin Beaver: 37.2 degrees Celcius'
  paste0('Mean body temperature of Jenny Meerkat:    ', 37.2+2*input$effect_size, ' degrees Celcius')
)


