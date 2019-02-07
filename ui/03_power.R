sidebarPanel(
  a(href="https://github.com/SurgicalInformatics/shinystats/blob/master/instructions/03_power.md",
    "Click for instructions", target="_blank"),
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
)