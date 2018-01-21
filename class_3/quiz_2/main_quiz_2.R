library(jsonlite)
library(httpuv)
library(httr)
library(XML)

key = "bd807dc7a8261ec392fa"
secret = "f9d6b9cd11555ae9f3e051b96035c4b2488e58c2"

myapi <- oauth_app("github",
                   key = key,
                   secret = secret)
github_token <- oauth2.0_token(
  oauth_endpoints('github'),myapi)

req <- 
  GET('https://api.github.com/users/jtleek/repos',
      config(token = github_token))

temp <- content(req)
temp1 <- jsonlite::fromJSON(toJSON(temp))

x <- htmlTreeParse('http://biostat.jhsph.edu/~jleek/contact.html',
                        useInternal = TRUE)
x <- read.fwf('https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for',
              widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4), skip = 4)                  