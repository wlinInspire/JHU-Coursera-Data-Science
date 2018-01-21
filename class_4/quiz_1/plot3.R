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
## Plot 3
plot(as.POSIXct(paste(powConTwo$Date, powConTwo$Time)),
     as.numeric(as.character(powConTwo$Sub_metering_1)), 
     ylab = 'Energy sub metering',
     xlab = '',
     type = 'l')
lines(as.POSIXct(paste(powConTwo$Date, powConTwo$Time)),
      as.numeric(as.character(powConTwo$Sub_metering_2)), 
      type = 'l', col = 'red')
lines(as.POSIXct(paste(powConTwo$Date, powConTwo$Time)),
      as.numeric(as.character(powConTwo$Sub_metering_3)), 
      type = 'l', col = 'blue')
legend('topright', lwd = 2,
       legend = c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       col = c('black', 'red', 'blue'), inset = 0.05, cex = 0.7, bty = 'n')
dev.copy(png,'./plot3.png')
dev.off()
