# Variables
* dataTidy: final tidy data 
* dataTidyMean: aggregated tidy data

# Data
* train: training data set of wearable device
* test: test data set of wearable device
* data: bind of train and test
* features: feature data set
* dataMeanStd: subset of data whose column names contain 'mean' and 'std'
* activityLableTrain: activity label in training set
* activityLableTest: activity label in test set
* activityLable: bind of activityLableTrain and activityLableTest
* activityDescription: mapping from activity labels to description
* subjectTrain: subjects in the training set
* subjectTest: subjects in the test set
* subject: bind of subjectTrain and subjectTest

# Transformations
* melt: to convert the original data set into long form and hence the data set becomes tidy
* aggregate: to calculate the average of reading value of wearable device