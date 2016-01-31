---
title: "Getting and cleanind data - final assigment"
author: "gosiasecret"
date: "31 stycznia 2016"
output: html_document
---
#Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

#Introduction

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Created R script called run_analysis.R does the following:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Download data
Load required packages
```{r}
library(dplyr)
library(httr) 
library(data.table)
```
Download the data and unzip it
```{r}
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
```

#Read and convert data
```{r}
path_rf = file.path("./data" , "UCI HAR Dataset")
files=list.files(path_rf, recursive=TRUE)
files
```
# 1. Merges the training and the test sets to create one data set
Read the proper data sets trains and tests.
```{r}
ActivityTest =read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain= read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTrain = read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest = read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  = read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain = read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
```
Combine X_train and X_test, y_train and y_test, subject_train subject_test into a new data frames call Subject, Activity, Features:
```{r}
Subject= rbind(SubjectTrain, SubjectTest)
Activity=rbind(ActivityTrain, ActivityTest)
Features= rbind(FeaturesTrain, FeaturesTest)
```
and rename
```{r}
names(Subject)=c("subject")
names(Activity)= c("activity")
FeaturesNames =read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)= FeaturesNames$V2
```
Combine all data into one data set
```{r}
Combine=cbind(Subject, Activity, Features)
```
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
Select all the columns that represent mean or standard deviation of the measurements with grep order.
```{r}
columnswMeanSTD = colnames(Combine[grepl("mean|std",colnames(Combine))])
Combine = Combine[,c("subject","activity",columnswMeanSTD)]
```
# 3. Uses descriptive activity names to name the activities in the data set
Replacing numeric labels of activity of the data frame by descriptive strings which come from the file activity_labels.txt.
```{r}
activityLabels =read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
```
# 4. Appropriately labels the data set with descriptive variable names.
With gsub rename column names:
```{r}
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
```
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Output tidy data set as "data_tidy.txt"
```{r}
tidy_data= aggregate(. ~subject + activity, Combine, mean)
write.table(x = tidy_data, file = "data_tidy.txt", row.names = FALSE)
```
