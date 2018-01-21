houseIdaho <- 
  read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')


library(dplyr)
x <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
              skip= 3)
x <- x[x$Ranking %in% 1:190,]
names(x)[1] <- 'CountryCode'
x <- x %>%
  select(CountryCode, Ranking,Economy,US.dollars.)

y <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
              check.names = F)
y <- y[,c("CountryCode","Long Name","Income Group","Special Notes")]

z <- merge(x,y) 
nrow(z[grep('Fiscal year end: June 30',z$`Special Notes`),])


library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
table(year(sampleTimes))

temp <- sampleTimes[year(sampleTimes) == 2012 ]
temp <- sampleTimes[year(sampleTimes) == 2012 & wday(sampleTimes) == 2]