install.packages("data.table")
install.packages("did")

library(data.table) ## For some minor data wrangling
library(dplyr)
library(did)

data_sued = read.csv("/Users/trevorbernard/Desktop/PythonFiles/ECMA\ 31320\ Project/datasuedpublicfinal.csv", 
                     header=TRUE)

data_trolled = read.csv("/Users/trevorbernard/Desktop/PythonFiles/ECMA\ 31320\ Project/datatrollpublicfinal.csv", 
                        header=TRUE)

data_sued$first.sued <- replace(data_sued$first.sued, 
                                data_sued$first.sued<2000, 10000)
data_sued$first.trolled <- replace(data_sued$first.trolled, 
                                   data_sued$first.trolled<2000, 10000)

data_trolled$first.sued <- replace(data_trolled$first.sued, 
                                   data_trolled$first.sued<2000, 10000)
data_trolled$first.trolled <- replace(data_trolled$first.trolled, 
                                      data_trolled$first.trolled<2000, 
                                      10000)

sued <- att_gt(yname = "patents",
               tname = "Year",
               idname = "Group",
               gname = "first.sued",
               xformla = ~Industry,
               clustervars = "Industry",
               data = data_sued)

troll <- att_gt(yname = "patents",
                tname = "Year",
                idname = "Group",
                gname = "first.trolled",
                xformla = ~Industry,
                clustervars = "Industry",
                data = data_trolled)


# summarize the results
print("Results for sued in the full sample:")
sued_agg.es <- aggte(sued, type = "dynamic")
summary(sued_agg.es)
ggdid(sued_agg.es, title="Sued: Full Sample", xlab = "Time to Treatment",
      ylab = "Treatment effect on Patents")

print("Results for trolled in the full sample:")
troll_agg.es <- aggte(troll, type = "dynamic", na.rm=TRUE)
summary(troll_agg.es)
ggdid(troll_agg.es, title="Troll: Full Sample", xlab = "Time to Treatment",
      ylab = "Treatment effect on Patents")