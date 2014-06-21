READ ME FILE FOR run_analysis.R
=========================================

Summary of run_analysis.R
----------------------------------------

run_analysis.R is an R script that will append the activity and subject id columns to the measurement variable test and training datasets.  It will merge the test and training datasets and filter on the mean and standard deviations variables.  Appropriate friendly column names are applied.  A final tidy data text file is outputted that summarizes the average of the mean and std varibles grouped by subject id and activity.  

Detailed Description
---------------------------------------

1. The script begins by reading the necessary files inside the UCI HAR Dataset folder then it reads the training and test datasets with the subject and activity columns appended.  
2. rbind(train_num, test_num) is used to merge the training and test datasets.
3. grep("-mean\\(\\)|-std\\(\\)",feature$measurement) is called to find only the mean and std variables.
4. merge(select,act,by.x="activity_id",by.y="id") is used to map activity ids to the activity friendly name.
5. grep("-mean\\(\\)|-std\\(\\)",feature$measurement, value=T) outputs the friendly columns names.
6. colnames(newmerge) <- c("activity_id",namecol,"subject_id","set","activity") is used to add friendly column names.
7. aggregate(cleanmerge[,!(names(cleanmerge) %in% c("subject_id","activity"))],by=list(cleanmerge$subject_id,cleanmerge$activity),FUN=mean,na.rm=T) groups the dataset by subject id and activity with the mean of each variable.
8. write.table(tidymean,"tidy_mean.txt",row.names=FALSE) writes the tidy dataset text file inside the working directory.


Assumptions
---------------------------------------
This script assumes the working directory is inside the UCI Har Dataset directory.

How to Run this Script successfully
---------------------------------------
*The script is logically sequential and all code should be run sequentially.

1. Set the working directory inside the UCI Har Dataset folder in R
2. Place the run_analysis.R script inside the home folder of the HCI Har Dataset folder
3. Load the R Script using this command source("run_analysis.R") in working directory.

Necessary Files
---------------------------------------
The files must be unzipped from this source location
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The following files are necessary for the script to run properly.
* features.txt
* activity_labels.txt
* subject_test.txt
* X_test.txt
* y_test.txt
* subject_train.txt
* X_train.txt
* y_train.txt

Folder structure should remain default from unzip of the original file.