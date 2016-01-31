library(dplyr)
library(httr) 
library(data.table)
'dowlnoading file'
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
'unzip file'
unzip(zipfile="./data/Dataset.zip",exdir="./data")
'what is in file'
path_rf = file.path("./data" , "UCI HAR Dataset")
files=list.files(path_rf, recursive=TRUE)
files
#1.Merges the training and the test sets to create one data set.
'Activity, Subject,Feature will be used'
'read files'
ActivityTest =read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain= read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTrain = read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest = read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  = read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain = read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
'Concatenate the data tables'
Subject= rbind(SubjectTrain, SubjectTest)
Activity=rbind(ActivityTrain, ActivityTest)
Features= rbind(FeaturesTrain, FeaturesTest)
'naming'
names(Subject)=c("subject")
names(Activity)= c("activity")
'names(Features)=c("features")' 
FeaturesNames =read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)= FeaturesNames$V2

'combine all data'
Combine=cbind(Subject, Activity, Features)
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
columnswMeanSTD = colnames(Combine[grepl("mean|std",colnames(Combine))])
Combine = Combine[,c("subject","activity",columnswMeanSTD)]
#3. Uses descriptive activity names to name the activities in the data set
activityLabels =read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
#4. Appropriately labels the data set with descriptive variable names.
NewNames=names(Combine)
NewNames=gsub("^t", "time", NewNames)
NewNames=gsub("^f", "frequency",NewNames)
NewNames=gsub("Acc", "Accelerometer", NewNames)
NewNames=gsub("Gyro", "Gyroscope", NewNames)
NewNames=gsub("Mag", "Magnitude", NewNames)
NewNames=gsub("BodyBody", "Body", NewNames)
NewNames=gsub("Gravity", "Gravity", NewNames)
NewNames=gsub("Body", "Body", NewNames)
NewNames=gsub("Jerk", "Jerk", NewNames)
NewNames=gsub("-mean", "-mean ", NewNames)
NewNames=gsub("-std", "-std ", NewNames)
names(Combine) =NewNames
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data= aggregate(. ~subject + activity, Combine, mean)
write.table(x = tidy_data, file = "data_tidy.txt", row.names = FALSE)
