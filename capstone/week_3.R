library(quanteda)
library(tm)
# Load Data
setwd('~/OneDrive - Knights - University of Central Florida/DataScience/JHUDataScience/capstone/')

blogs <- readLines('./final/en_US/en_US.blogs.txt', encoding = "UTF-8")
news <- readLines('./final/en_US/en_US.news.txt', encoding = "UTF-8")
twitter <- readLines('./final/en_US/en_US.twitter.txt', encoding = "UTF-8",
                     warn = FALSE)

sample_ratio <- 0.1
blogs_sample <- blogs[sample(1:length(blogs), size = length(blogs) * sample_ratio)]
news_sample <- news[sample(1:length(news), size = length(news) * sample_ratio)]
twitter_sample <- twitter[sample(1:length(twitter), size = length(twitter) * sample_ratio)]
cps <- corpus(c(blogs_sample, news_sample, twitter_sample))

# Training
n_gram_features <- list()
for (i in 2:4) {
  print(paste0('training..', i))
  mydfm_i <- dfm(cps , ngrams = i,stem = T,
                 remove_numbers = T, remove_symbols = T, remove_punct = T,
                 remove = stopwords("english"))
  mydfm_i <- dfm_trim(mydfm_i, min_count = 4)
  n_gram_features[[as.character(i)]] <- mydfm_i %>% colSums()
}

# save(n_gram_features, file = './model/n_gram_model_2_to_4.rda')
load(file = './model/n_gram_model_2_to_4.rda')

# Predict
predict_next_word <- function(n_gram, max_gram = 4) {
  # browser()
  # parse input sentense to word vector
  # features <- dfm(n_gram
  #                 # , remove_numbers = T, remove_symbols = T, remove_punct = T
  #                 # , remove = stopwords("english")
  #                 )
  # features <- features@Dimnames$features
  features <- strsplit(n_gram, ' ')[[1]]
  features <- features %>% tail(max_gram - 1)

  # Predict using model that has 1 order higher than the input word vector
  for(i in length(features):1) {
    kw <- paste0(paste0(features[1:i], collapse = '_'), '_')

    mydfm_i <- n_gram_features[[as.character(i + 1)]]
    pred <- mydfm_i[grepl(kw, names(mydfm_i))] %>% sort(decreasing = TRUE) %>%
      head(1)
    if (length(pred) == 0) {
      next
    } else {
      print(gsub(kw, '', names(pred)))
      break
    }
  }
}

predict_next_word("The guy in front of me just bought a pound of bacon, a bouquet, and a case of")
predict_next_word("You're the reason why I smile everyday. Can you follow me please? It would mean the")
predict_next_word("Hey sunshine, can you follow me and make me the")
predict_next_word("Very early observations on the Bills game: Offense still struggling but the")
predict_next_word("Go on a romantic date at the")
predict_next_word("Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my")
predict_next_word("Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some")
predict_next_word("After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little")
predict_next_word("Be grateful for the good times and keep the faith during the")
predict_next_word("If this isn't the cutest thing you've ever seen, then you must be")
