houseIdaho <- read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')

agricultureLogical <-
  houseIdaho$ACR == 3 & houseIdaho$AGS == 6

which(agricultureLogical)


library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",
              "~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/JHUDataScience/quiz/quiz_3/pic.jpg")
x <- readJPEG('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/JHUDataScience/quiz/quiz_3/pic.jpg', 
              native = T)

quantile(x,probs = c(0.3,0.8))

library(dplyr)
x <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
              skip= 3)

x <- x[x$Ranking %in% 1:190,]
names(x)[1] <- 'CountryCode'
x <- x %>%
  select(CountryCode, Ranking,Economy,US.dollars.)

y <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
              check.names = F)
y <- y[,c("CountryCode","Long Name","Income Group")]

z <- merge(x,y) 
z$Ranking <- as.numeric(as.character(z$Ranking))
z <- z[order(z$Ranking, decreasing = T),]


sort(z$Ranking[z$`Income Group`== "Lower middle income"])



