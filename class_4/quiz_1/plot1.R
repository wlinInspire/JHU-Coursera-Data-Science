## Set working directory
setwd('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/')
setwd('./JHUDataScience/Class_4_exploratory_analysis/quiz_1/ExData_Plotting1/')
## Load Library
library(dplyr)
## Read data
powCon <- read.table('../household_power_consumption.txt', sep = ';',
                     header = TRUE)
powCon <- mutate(powCon, Date = as.Date(Date, '%d/%m/%Y'))
powConTwo <- filter(powCon, 
                    Date %in% c(as.Date('2007-02-01'), as.Date('2007-02-02')))
## Plot 1
hist(as.numeric(as.character(powConTwo$Global_active_power)), 
     main = 'Global Active Power',
     xlab = 'Gloabl Active Power (kilowatts)',
     col = 'red')
dev.copy(png,'./plot1.png')
dev.off()
