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