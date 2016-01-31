---
title: "README"
author: "gosiasecret"
date: "31 stycznia 2016"
---
This repo explains how all of the scripts work and how they are connected in a frame of final project of Getting and Cleaning Data Course.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Created R script called run_analysis.R that does the following.  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

Uploaded files:  
- run_analysis.R- R code of the process described aboove.  
- data_tidy.txt - output text file  
- CodeBook.md - data processing decription  
- README.md - repository description  
 