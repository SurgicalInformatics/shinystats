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
