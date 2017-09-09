### Matt Ostberg 9/8/2017
### This takes the datasets supplied from
### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
### Joins them, cleans them up and extracts the mean, std dev for each activity
### and summarizes the variables by subject/activity pair to give the mean

library(dplyr)

## read in all the files assuming base directory has the unzipped file/dir in it 
subject_test <- read.delim("UCI HAR Dataset/test/subject_test.txt", header=F, sep = "")
y_test <- read.delim("UCI HAR Dataset/test/y_test.txt", header=F, sep = "")
X_test <- read.delim("UCI HAR Dataset/test/X_test.txt", header=F, sep = "")
subject_train <- read.delim("UCI HAR Dataset/train/subject_train.txt", header=F, sep = "")
y_train <- read.delim("UCI HAR Dataset/train/y_train.txt", header=F, sep = "")
X_train <- read.delim("UCI HAR Dataset/train/X_train.txt", header=F, sep = "")
ActivityLabels <- read.delim("UCI HAR Dataset/activity_labels.txt", header = F, sep = "")
features <- read.delim("UCI HAR Dataset/features.txt", header = F, sep ="")

## Join the files together
y_test_names <- left_join(y_test, ActivityLabels, by = c("V1" = "V1"))
y_train_names <- left_join(y_train, ActivityLabels)

## an assumption here is the subjects and activities are in the same order
## if they're not, the dataset is unusable anyway
## so merge the files by adding the subject column to test and train
y_test_names$subject <- subject_test$V1
y_train_names$subject <- subject_train$V1

## use the features file to give the columns names. Again assuming the
## structure of the files is the same, since they have to be in order to be usable
names(X_test) <- features$V2
names(X_train) <- features$V2
names(y_test_names) <- c("activity", "activityname", "subject")
names(y_train_names) <- c("activity", "activityname", "subject")

## make the test and train files complete by binding
testdf <- cbind(y_test_names, X_test)
traindf <- cbind(y_train_names, X_train)

## join the test and training files together. They have the same column names now
## so we can just jam them together and let rbind figure it out
wholedf <- rbind(testdf, traindf)

## throw away the columns that aren't the labels activity/subject
## or the mean/std columns
reduceddf <- wholedf[, grep('mean\\(|std\\(|activity|subject', colnames(wholedf))]

## use dplyr to group and summarize (summarise) the data for each column
## this works because I group by activityname, and the average of the activity 
## number for that activity is the activity number itself.
groupeddf <- reduceddf %>% group_by(activityname,subject) %>% summarise_all(mean)
