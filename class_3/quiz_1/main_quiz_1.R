# Quiz 1 & 2
setwd('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/JHUDataScience/')

download.file(
  url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv',
  destfile = './quiz/quiz_1/temp.csv')

temp <- read.csv('./quiz/quiz_1/temp.csv')

nrow(temp[temp$VAL == 24,]) 

# Quiz 3
download.file(
  url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx',
  destfile = './quiz/quiz_1/temp.xlsx'
)
require(xlsx)
# rows 18-23 and columns 7-15
dat <- read.xlsx('./quiz/quiz_1/temp.xlsx',sheetIndex = 1,
                  startRow = 18, endRow = 23,colIndex = 7:15)

sum(dat$Zip*dat$Ext,na.rm=T)

# Quzi 4

require(XML)
# 
# Read the XML data on Baltimore restaurants from here:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# 
# How many restaurants have zipcode 21231?

download.file(
  url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml',
  destfile = './quiz/quiz_1/temp.xml'
)

temp <- xmlTreeParse('./quiz/quiz_1/temp.xml',useInternalNodes = TRUE)

zipcodes <- xpathApply(temp,'//zipcode',xmlValue)

zipcodes <- sapply(zipcodes,function(x) {x[1]})

sum(zipcodes == '21231')


# Quiz 5
# 
# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
# using the fread() command load the data into an R object
# 
# DT
# The following are ways to calculate the average value of the variable
# 
# pwgtp15
# broken down by sex. Using the data.table package, which will deliver the fastest user time?
require(data.table)
DT <- fread('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv')
