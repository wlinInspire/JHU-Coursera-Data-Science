setwd('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/JHUDataScience/')
dataSet <- read.csv('./Class_2_R_programming/quiz_1/hw1_data.csv')

temp <- dataSet[dataSet$Ozone >31 & 
                        dataSet$Temp > 90,]

mean(temp$Solar.R,na.rm = T)

mean(dataSet$Temp[dataSet$Month == 6],na.rm = T)

max(dataSet$Ozone[dataSet$Month == 5],na.rm = T)