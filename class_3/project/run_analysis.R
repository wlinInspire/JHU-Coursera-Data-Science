# load library
library(reshape2)

# Set working directory
setwd(paste0('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/',
             'JHUDataScience/Class_3_Clean_Data/project/CourseraClass3Project'))

# Read training, test, and feature name data sets
train <- read.table('../UCI HAR Dataset/train/X_train.txt')
test <- read.table('../UCI HAR Dataset/test/X_test.txt')
features <- read.table('../UCI HAR Dataset/features.txt')

# Rename data sets by feature names
names(train) <- features$V2
names(test) <- features$V2

# Combine training and test sets
data <- rbind(train,test)

# Find columns with their names containing 'mean' and 'std'
dataMeanStd <- data[,c(grep('mean',names(data)), grep('std',names(data)))]

# Read activity label and description in training and test sets
activityLableTrain <- read.table('../UCI HAR Dataset/train/y_train.txt')
activityLableTest <- read.table('../UCI HAR Dataset/test/y_test.txt')
activityLable <- rbind(activityLableTrain,activityLableTest)
activityDescription <- read.table('../UCI HAR Dataset/activity_labels.txt')

# Map labels to their desctiptions
activityLable <- merge(activityLable,activityDescription,sort = F)
names(activityLable)[2] <- 'activity'
dataMeanStd <- cbind(activity = activityLable$activity, dataMeanStd)

# Read subjects in training and test sets
subjectTrain <- read.table('../UCI HAR Dataset/train/subject_train.txt')
subjectTest <- read.table('../UCI HAR Dataset/test/subject_test.txt')
subject <- rbind(subjectTrain,subjectTest)
names(subject)[1] <- 'subject'
dataMeanStd <- cbind(subject, dataMeanStd)

# Convert to long tidy form
dataTidy <- dataMeanStd
dataTidy <- melt(dataTidy, id.vars = c('activity', 'subject'))

# Aggregate data to calculate average variable value for 
# different activity and subject
dataTidyMean <- aggregate(cbind(average_value = value) ~ 
                    activity + subject + variable, dataTidy, mean)

# Save tidy data set
write.table(dataTidyMean,'../script/CourseraDataScience/tidy.txt',
            row.name=FALSE)