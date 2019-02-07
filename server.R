# https://argonaut.is.ed.ac.uk/shiny/rots/stat_month/

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

  source(here::here("server", "01_ttest.R"),  local = TRUE)$value
  source(here::here("server", "02_chisquared.R"),  local = TRUE)$value
  source(here::here("server", "03_power.R"),  local = TRUE)$value
  
})







