library(quanteda)
library(data.table)
# Load Data
setwd('~/OneDrive - Knights - University of Central Florida/DataScience/JHUDataScience/capstone/')

blogs <- readLines('./final/en_US/en_US.blogs.txt', encoding = "UTF-8")
news <- readLines('./final/en_US/en_US.news.txt', encoding = "UTF-8")
twitter <- readLines('./final/en_US/en_US.twitter.txt', encoding = "UTF-8",
                     warn = FALSE)
total <- c(blogs, news, twitter)
rm(blogs, news, twitter)


set.seed(1234)
partitions <- 10
# blog_idx <- sample(1:partitions, length(blogs), replace = TRUE)
# news_idx <- sample(1:partitions, length(news), replace = TRUE)
# twitter_idx <- sample(1:partitions, length(twitter), replace = TRUE)
total_idx <- sample(1:partitions, length(total), replace = TRUE)
total_sample <- total[total_idx == 1]


cps <- corpus(total_sample)

# n_gram model
n_gram_frequency_table <- data.table()
for (i in 2:4) {
  print(paste0('training..', i))
  mydfm_i <- dfm(cps, ngrams = i,
                 remove_numbers = T, remove_symbols = T, remove_punct = T)
  # mydfm_i <- dfm_trim(mydfm_i, min_count = 1)
  word_freq <- colSums(mydfm_i)

  preceding_words <- sapply(names(word_freq), function(x) {
    word_split <- strsplit(x, '_')[[1]]
    paste0(head(word_split, -1), collapse = '_')
  })
  last_word <- sapply(names(word_freq), function(x) {
    word_split <- strsplit(x, '_')[[1]]
    tail(word_split, 1)
  })

  temp <- data.table(n_gram = names(word_freq),
                     frequency = word_freq,
                     preceding_words = preceding_words,
                     last_words = last_word,
                     type = paste0(i,'_gram'))
  # mydfm_i <- dfm_trim(mydfm_i, min_count = 4)
  n_gram_frequency_table <- n_gram_frequency_table %>% rbind(temp)
}

n_gram_frequency_table_trim <- n_gram_frequency_table[frequency > 2]

# save(n_gram_frequency_table_trim,
# file = './model/n_gram_model_freq_table_2_to_4.rda')
load(file = './model/n_gram_model_freq_table_2_to_4.rda')

# Predict
predict_next_word <- function(input, max_gram = 3,
                              freq_table = n_gram_frequency_table_trim) {
  # convert last 3 words of input sentense to 1 to 3 gram

  ng_list <- data.table()
  for (ng in 1:max_gram) {
    features <- tokens(input, remove_numbers = T, remove_symbols = T,
                       remove_punct = T, ngrams = ng)
    temp <- data.table(preceding_words = features$text1 %>% tail(1),
                       type = paste0(ng + 1,'_gram'))
    ng_list <- ng_list %>% rbind(temp)
  }

  # Predict using model that has 1 order higher than the input word vector
  first_10 <- freq_table[ng_list, on = .(preceding_words, type)] %>%
    .[!is.na(frequency)] %>%
    .[order(type, frequency, decreasing = TRUE)] %>%
    head(10)
  first_10
}

predict_next_word("When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd")
predict_next_word("Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his")
predict_next_word("I'd give anything to see arctic monkeys this")
predict_next_word("Talking to your mom has the same effect as a hug and helps reduce your")
predict_next_word("When you were in Holland you were like 1 inch away from me but you hadn't time to take a")
predict_next_word("I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the")
predict_next_word("I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each")
predict_next_word("Every inch of you is perfect from the bottom to the")
predict_next_word("I’m thankful my childhood was filled with imagination and bruises from playing")
predict_next_word("I like how the same people are in almost all of Adam Sandler's")
