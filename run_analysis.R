## Getting and Cleaning data Peer Review
library(dplyr)
library(reshape2)

# setwd("D:\\coursera")

## Download data  (ms windows curl not used)
zipfilename <- "wearabledata.zip"
if (!file.exists("./data")){dir.create("./data")}
if (!file.exists(zipfilename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, zipfilename)
}

## Uncompress the file
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Load and Read the features data
##    Column   Description
##    --------------------
##    v1       Id of feature
##    v2       Description of feature
featureData <- read.table("UCI HAR Dataset/features.txt")
featureData[,2] <- as.character(featureData[,2])

## Extracts only the measurements on the mean and standard deviation for each measurement 
## from the features using the description
features <- filter(featureData, grepl("*mean*|*std*", V2, ignore.case = FALSE)) %>%
  filter(!grepl("meanFreq", V2, ignore.case = TRUE))

## Tidy the features data
colnames(features) <- c("id","name")
features$name = gsub('-mean', 'Mean', features$name)
features$name = gsub('-std()', 'Std', features$name)
features$name = gsub("Mean[(][)]","Mean", features$name)
features$name = gsub("Std[(][)]","Std", features$name)

## Load and Read the activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## Load and read the training features data
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")
train <- trainData[features$id]

## Load and read the traning activities
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")

## Load and read the subjects
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Merge the data training data, activities and subjects
train <- cbind(trainSubjects, trainActivities, train)

## Load the test data and filter by features
testData <- read.table("UCI HAR Dataset/test/X_test.txt")
test <- testData[features$id]

testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

## merge the test and training data using row bind
testTrainData <- rbind(train, test)

## tidy the data by adding column names for subject and activity
colnames(testTrainData) <- c("subject", "activity", features$name)

## turn activities & subjects into factors (counting the frequencies of each)
##  levels is the numeric value of the activity  activityLabels[,1] column 1
##  labels is the description of the activity    activityLabels[,2] column2
testTrainData$activity <- factor(testTrainData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
testTrainData$subject <- factor(testTrainData$subject)

## Calculate the average for each subject/activity
testTrainData.melted <- melt(testTrainData, id = c("subject","activity"))
testTrainData.mean <- dcast(testTrainData.melted, subject + activity ~ variable, mean)

## Write the data to disk
write.table(testTrainData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
