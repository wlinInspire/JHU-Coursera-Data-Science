library(quanteda)
library(data.table)
# Load Data
setwd('~/OneDrive - Knights - University of Central Florida/DataScience/JHUDataScience/capstone/')

load(file = './model/n_gram_model_freq_table_2_to_4.rda')
load(file = 'test_set.rda')

total_test <- tolower(total_test)

test_list <- data.table()
for (i in 2:4) {
  for (j in 1:length(total_test)) {
    token_j <- tokens(total_test[j], remove_numbers = T, remove_symbols = T,
                      remove_punct = T, ngrams = i)
    if (length(token_j$text1) == 0) {
      next
    }
    preceding_words <- sapply(token_j$text1,
                             function(x) paste0(strsplit(x, '_')[[1]] %>% head(-1),
                                                collapse = '_'))
    last_word <- sapply(token_j$text1,
                        function(x) strsplit(x, '_')[[1]] %>% tail(1))
    temp <- data.table(preceding_words = preceding_words,
                       last_word_actual = last_word)
    test_list <- test_list %>% rbind(temp)
  }
}

# Predict
prediction_performance <- function(input, max_gram = 3,
                                   freq_table = n_gram_frequency_table_trim) {
  # browser()
  input <- tolower(input)
  actual_last <- strsplit(input, '_')[[1]] %>% tail(1)
  # convert last 3 words of input sentense to 1 to 3 gram
  ng_list <- data.table()
  for (ng in 1:max_gram) {
    features <- tokens(input, remove_numbers = T, remove_symbols = T,
                       remove_punct = T, ngrams = ng)
    if (length(features$text1) > 0) {
      temp <- data.table(preceding_words = features$text1 %>% tail(1),
                         type = paste0(ng + 1,'_gram'))
      ng_list <- ng_list %>% rbind(temp)
    }
  }

  # Predict using model that has 1 order higher than the input word vector
  pred <- freq_table[ng_list, on = .(preceding_words, type)] %>%
    .[!is.na(frequency)] %>%
    .[order(type, frequency, decreasing = TRUE)]

  list(pred$last_words %>% head(3))
}

test_list$pred <- sapply(test_list$preceding_words, prediction_performance)

mean(test_list$last_word_actual %in% test_list$pred)

save(test_list, file = './model/test_result.rda')


