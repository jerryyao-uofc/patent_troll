
library(data.table) ## For some minor data wrangling
library(fixest)
library(dplyr)

datatroll = read.csv("C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datatroll.csv", 
                     header=TRUE)

troll = feols(patents ~ sunab(first.trolled, Year) + 
                Public + troll.indic | 
                industry + correspondence_name,
              cluster = ~industry,
              data = datatroll)

iplot(troll, 
      xlab = 'Time to treatment',
      main = 'Troll: Full Dataset')
