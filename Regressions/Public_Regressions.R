
library(data.table) ## For some minor data wrangling
library(fixest)
library(dplyr)

datasuedpublic = read.csv("C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datasuedpublic.csv", 
                header=TRUE)
datatrollpublic = read.csv("C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datatrollpublic.csv", 
                           header=TRUE)

suedpublicmc = feols(patents ~ sunab(first.sued, Year) + ## Our key interaction: time × treatment status
               sued.indic + Market.Cap..millions. |                    ## Other controls
               S.P.industry.code + correspondence_name,          ## FEs
             cluster = ~S.P.industry.code,                          ## Clustered SEs
             data = datasuedpublic)

trollpublicmc = feols(patents ~ sunab(first.trolled, Year) + ## Our key interaction: time × treatment status
                troll.indic + Market.Cap..millions. |                    ## Other controls
                S.P.industry.code + correspondence_name,          ## FEs
              cluster = ~S.P.industry.code,
              data = datatrollpublic)

suedpublicemp = feols(patents ~ sunab(first.sued, Year) + ## Our key interaction: time × treatment status
                       sued.indic + data.Employees..thousands |                    ## Other controls
                       S.P.industry.code + correspondence_name,          ## FEs
                     cluster = ~S.P.industry.code,                          ## Clustered SEs
                     data = datasuedpublic)

trollpublicemp = feols(patents ~ sunab(first.trolled, Year) + ## Our key interaction: time × treatment status
                        troll.indic + data.Employees..thousands |                    ## Other controls
                        S.P.industry.code + correspondence_name,          ## FEs
                      cluster = ~S.P.industry.code,
                      data = datatrollpublic)

suedpublicta = feols(patents ~ sunab(first.sued, Year) + ## Our key interaction: time × treatment status
                       sued.indic + Total.Assets..millions. |                    ## Other controls
                       S.P.industry.code + correspondence_name,          ## FEs
                     cluster = ~S.P.industry.code,                          ## Clustered SEs
                     data = datasuedpublic)

trollpublicta = feols(patents ~ sunab(first.trolled, Year) + ## Our key interaction: time × treatment status
                        troll.indic + Total.Assets..millions. |                    ## Other controls
                        S.P.industry.code + correspondence_name,          ## FEs
                      cluster = ~S.P.industry.code,
                      data = datatrollpublic)

iplot(suedpublicmc, 
      xlab = 'Time to treatment',
      main = 'Sued: Market Cap')
iplot(trollpublicmc, 
      xlab = 'Time to treatment',
      main = 'Troll: Market Cap')
iplot(suedpublicemp, 
      xlab = 'Time to treatment',
      main = 'Sued: Employees')
iplot(trollpublicemp, 
      xlab = 'Time to treatment',
      main = 'Troll: Employees')
iplot(suedpublicta, 
      xlab = 'Time to treatment',
      main = 'Sued: Total Assets')
iplot(trollpublicta, 
      xlab = 'Time to treatment',
      main = 'Troll: Total Assets')

