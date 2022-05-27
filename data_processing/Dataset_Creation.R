
install.packages('fixest')
library(data.table) ## For some minor data wrangling
library(fixest)
library(dplyr)

data = read.csv("C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/final_data.csv", 
                header=TRUE)

data = select(data,-c(X,Unnamed..0,Unnamed..0_x, Unnamed..0_y, Unnamed..0.1, Unnamed..0.1.1))

datatemp = select(data, -c(Employees..thousands.))
datatemp[is.na(datatemp)] <- 0
datatemp = cbind(datatemp, data$Employees..thousands)

sued_rows_to_keep = which(datatemp$first.sued != 2000)
troll_rows_to_keep = which(datatemp$first.trolled != 2000)

datasued = datatemp[sued_rows_to_keep,]
datasued$time_to_treat = ifelse(datasued$first.sued != 0, 
                                datasued$Year - datasued$first.sued, 0)

datatroll = datatemp[troll_rows_to_keep,]
datatroll$time_to_treat = ifelse(datatroll$first.trolled != 0, 
                                 datatroll$Year - datatroll$first.trolled, 0)

write.csv(datasued,"C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datasued.csv", row.names = FALSE)
write.csv(datatroll,"C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datatroll.csv", row.names = FALSE)

sued = feols(patents ~ i(time_to_treat, first.sued, ref = -1) + ## Our key interaction: time × treatment status
               Public + sued.indic |                    ## Other controls
               industry + correspondence_name,          ## FEs
             cluster = ~industry,                          ## Clustered SEs
             data = datasued)

troll = feols(patents ~ i(time_to_treat, first.trolled, ref = -1) + 
                Public + troll.indic | 
                industry + correspondence_name,
              cluster = ~industry,
              data = datatroll)

public_sued = which(datasued$Always.Public == 1)
public_troll = which(datatroll$Always.Public == 1)

datasuedpublic = datasued[public_sued,]
datatrollpublic = datatroll[public_troll,]

write.csv(datasuedpublic,"C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datasuedpublic.csv", row.names = FALSE)
write.csv(datatrollpublic,"C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/datatrollpublic.csv", row.names = FALSE)
