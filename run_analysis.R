library(reshape2)
library(dplyr)



## Upload data to data folder
if(!file.exists("./data")){dir.create("./data")}
fileURL <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data <-download.file(fileURL, destfile = "./data/asign4.zip", method = "auto")
unzip ("./data/asign4.zip", exdir="./data")

## Labels
datalabels <- read.table("./data/UCI HAR Dataset/features.txt")
datalabels <- as.vector(datalabels$V2)
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## Create train set
trainSs <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
names(trainSs) <- "id"
train_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
names(train_labels) <- "activity"
traindata <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
names(traindata) <- datalabels
train<-cbind(trainSs, train_labels, traindata)


##Create test set
testSs <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
names(testSs) <- "id"
test_labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
names(test_labels) <-"activity"
testdata <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
names(testdata) <- datalabels
test<-cbind(testSs, test_labels, testdata)

##combine data and remove temp files
combineddata <- combineddata <- rbind(train, test)
levels(combineddata$activity) <- activity_labels$V2
rm(list=setdiff(ls(), "combineddata"))

##Extract measurements on mean and standard deviation for each measurement
meanstd<- combineddata[,grepl("mean()|std()|id|activity", colnames(combineddata))]
meanstd<-select(meanstd, -contains("meanFreq"))

##Rename variable labels
names(meanstd)<-gsub("^t", "time", names(meanstd))
names(meanstd)<-gsub("^f", "frequency", names(meanstd))
names(meanstd)<-gsub("Acc", "Accelerometer", names(meanstd))
names(meanstd)<-gsub("Gyro", "Gyroscope", names(meanstd))
names(meanstd)<-gsub("Mag", "Magnitude", names(meanstd))
names(meanstd)<-gsub("BodyBody", "Body", names(meanstd))


##Average across 
meanstdlong <- melt(meanstd, id = c("id", "activity"))
meanstdwide <- dcast(meanstdlong, id + activity ~ variable, mean)

##save tidy data
setwd("./data")
write.table(all.data.wide, file = "tidydata.txt", row.names = FALSE)
