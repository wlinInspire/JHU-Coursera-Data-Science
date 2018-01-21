x <- read.csv('hw1_data.csv')

x[is.na(x[,'Ozone']),'Ozone'] <- 0

ozone31 = x[,'Ozone']>31
temp90 = x[,'Temp']>90

output <- mean(x[ozone31&temp90,'Solar.R'])

