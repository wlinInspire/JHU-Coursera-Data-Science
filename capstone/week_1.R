en_US.twitter <- readLines('./capstone/final/en_US/en_US.twitter.txt')
max(nchar(en_US.twitter))

sum(grepl('love', en_US.twitter)) /
  sum(grepl('hate', en_US.twitter))

en_US.twitter[grepl('biostats', en_US.twitter)]

en_US.twitter[grepl('A computer once beat me at chess, but it was no match for me at kickboxing',
                    en_US.twitter)]

en_US.blogs <- readLines('./capstone/final/en_US/en_US.blogs.txt')
max(nchar(en_US.blogs))


en_US.news <- readLines('./capstone/final/en_US/en_US.news.txt')
max(nchar(en_US.news))
