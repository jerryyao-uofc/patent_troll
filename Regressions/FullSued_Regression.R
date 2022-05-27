
library(data.table) ## For some minor data wrangling
library(fixest)
library(dplyr)

datasued = read.csv("C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datasued.csv", 
                          header=TRUE)

datasued = select(datasued, c(patents, first.sued, Year, Public, sued.indic, sued, 
             industry, correspondence_name, time_to_treat))

sued = feols(patents ~ sunab(first.sued, Year) + ## Our key interaction: time × treatment status
               Public + sued.indic |                    ## Other controls
               industry + correspondence_name,   ## FEs
             cluster = ~industry,                       ## Clustered SEs
             data = datasued)

iplot(sued, 
      xlab = 'Time to treatment',
      main = 'Sued: Full Dataset')
