
# quiz 2 ------------------------------------------------------------------
library(AppliedPredictiveModeling)
data(AlzheimerDisease)

library(caret)
adData = data.frame(predictors)

adData = data.frame(diagnosis,predictors)


library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(ggplot2)

ggplot(mixtures) + 
  geom_point(aes(x = 1:nrow(mixtures),
                 y = CompressiveStrength,
                 col = cut(Cement,breaks = 5)))

ggplot(mixtures) + 
  geom_histogram(aes(x = Superplasticizer),bins = 100)

library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

training_sub <- training[, grepl('^IL_',names(training))]

x <- preProcess(training_sub, method = c('center', 'scale', 'pca'), thresh = 0.9)


library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


training_sub <- training[,c(grep('^IL_',names(training)),
                             grep('^diagnosis',names(training)))]
fit <- train(diagnosis~., training_sub, method = 'glm')
mean(testing$diagnosis == predict(fit, testing))

preProcess <- preProcess(training_sub, method = c('pca'), thresh = 0.8)
fit <- train(diagnosis~., predict(preProcess, training_sub), method = 'glm')
mean(testing$diagnosis == predict(fit, predict(preProcess, testing)))

# quiz 3 ------------------------------------------------------------------

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

set.seed(125)

training <- segmentationOriginal[segmentationOriginal$Case == 'Train',]
testing <- segmentationOriginal[segmentationOriginal$Case == 'Test',]


fit <- train(Class ~ .-Case, data = training, method = 'rpart')

newdata = data.frame(TotalIntench2 = 23000,
                     FiberWidthCh1 = 10,
                     PerimStatusCh1 = 2)

newdata$Cell <- NA


print(fit$finalModel)


library(pgmm)
data(olive)
olive = olive[,-1]

fit <- train(Area ~ ., data = olive, method = 'rpart')


predict(fit, newdata = as.data.frame(t(colMeans(olive))))



library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)

fit <- train(as.character(chd) ~ age + alcohol + obesity  + tobacco +
               typea + ldl, 
             data = trainSA, method = 'glm',
             family='binomial')

missClass = function(values,prediction){
  sum(((prediction > 0.5)*1) != values)/length(values)
}

missClass(trainSA$chd,
          as.integer(as.character(predict(fit, trainSA))))

missClass(testSA$chd,
          as.integer(as.character(predict(fit, testSA))))


library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)
fit <- train(y ~ ., 
             data = vowel.train, method = 'rf')
varImp(fit)

# quiz4 -------------------------------------------------------------------
library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)

fit_rf <- train(y ~ .,  data = vowel.train, method = 'rf')
fit_gbm <- train(y ~ .,  data = vowel.train, method = 'gbm', verbose = FALSE)

test_rf <- predict(fit_rf, newdata = vowel.test)
test_gbm <- predict(fit_gbm, newdata = vowel.test)

mean(vowel.test$y == test_rf)
mean(vowel.test$y == test_gbm)
mean(vowel.test$y[test_rf == test_gbm] == test_rf[test_rf == test_gbm])



library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433)

fit_rf <- train(diagnosis ~ .,  data = training, method = 'rf')
fit_gbm <- train(diagnosis ~ .,  data = training, method = 'gbm', verbose = FALSE)
fit_lda <- train(diagnosis ~ .,  data = training, method = 'lda')

training$rf <- predict(fit_rf, newdata = training)
training$gbm <- predict(fit_gbm, newdata = training)
training$lda <- predict(fit_lda, newdata = training)

testing$rf <- predict(fit_rf, newdata = testing)
testing$gbm <- predict(fit_gbm, newdata = testing)
testing$lda <- predict(fit_lda, newdata = testing)

mean(testing$rf == testing$diagnosis)
mean(testing$gbm == testing$diagnosis)
mean(testing$lda == testing$diagnosis)

fit_rf_stacked <- train(diagnosis ~ .,  data = training, method = 'rf')

mean(predict(fit_rf_stacked, newdata = testing) == testing$diagnosis)



set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(233)

fit_lasso <- train(CompressiveStrength ~ ., data = training, method = 'lasso')
plot.enet(fit_lasso$finalModel)


library(lubridate) # For year() function below

dat = read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv")

training = dat[year(dat$date) < 2012,]

testing = dat[(year(dat$date)) > 2011,]

tstrain = ts(training$visitsTumblr)
fit_ts <- forecast::bats(tstrain)
fcst <- forecast::forecast(fit_ts, level = 95, h = nrow(testing))

mean(testing$visitsTumblr >= fcst$lower & 
  testing$visitsTumblr <= fcst$upper)


set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[ -inTrain,]

set.seed(325)

fit_svm <- e1071::svm(CompressiveStrength ~., data = training)
testing$pred <- predict(fit_svm, testing)
sqrt(mean((testing$pred - testing$CompressiveStrength)^2))