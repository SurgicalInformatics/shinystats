sidebarPanel(
  a(href="https://github.com/SurgicalInformatics/shinystats/blob/master/instructions/02_chisquared.md",
    "Click for instructions", target="_blank"),
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
)