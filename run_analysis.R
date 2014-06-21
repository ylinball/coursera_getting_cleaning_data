#Getting and Cleaning Data
#Course Project

## You should create one R script called run_analysis.R that does the following. 

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Clear all variables
rm(list=ls(all=TRUE))

# Set default working directory to Samsung Data Folder

# Retrieve working directory
getwd()

# List file sin working directory
list.files()

#****************************READ LABELS and FEATURE COLUMNS***********************************

#get activity labels per row in test/train
act <- read.table("activity_labels.txt")
colnames(act) <- c("id","activity")

#read the column labels for test and training sets
feature <- read.table("features.txt")
colnames(feature) <- c("id","measurement")


#****************************READ TEST DATASET**************************************



#read measurements of features in x_test
test_num<-read.table("test/X_test.txt")

#read activity per row of x_test
test_act<-read.table("test/y_test.txt")
colnames(test_act) <- "activity_id"

#read test subject per row of x_test
test_sub<-read.table("test/subject_test.txt")
colnames(test_sub) <- "subject_id"

#****************************READ TRAINING DATASET***********************************

#read measurements of features in X_train
train_num<-read.table("train/X_train.txt")

#read activity per row of X_train
train_act<-read.table("train/y_train.txt")
colnames(train_act) <- "activity_id"

#read test subject per row of X_train
train_sub<-read.table("train/subject_train.txt")
colnames(train_sub) <- "subject_id"

#****************************PART ONE***********************************

### Merges the training and the test sets to create one data set.
#Step 1 - Add columns of subject and activity to test and train dataset.
test_num<-cbind(test_num,test_act)
#test_num$activity <- test_act *** Don't use because it creates data frames
test_num<-cbind(test_num,test_sub)

train_num<-cbind(train_num,train_act)
train_num<-cbind(train_num,train_sub)

#Step 2 - Need to add new column to indicate data from test or train dataset
testset <- rep("test",nrow(test_num))
#Or can be done using testset <- "test"
test_num$set <- testset

trainset <- rep("train",nrow(train_num))
#Or can be done using trainset <- "train"
train_num$set <- trainset

#Step 3 - Merge test and train datasets together
merged <- rbind(train_num, test_num)

#****************************PART TWO***********************************

#Step 4 - Select on columns mean and std based on text matching of feature column

col <- grep("-mean\\(\\)|-std\\(\\)",feature$measurement)
newcol <- c(col,562:564)
select <- merged[,newcol]

#****************************PART THREE***********************************

#Step 5 - Include friendly names from activity label using merge

newmerge <- merge(select,act,by.x="activity_id",by.y="id")


#****************************PART FOUR***********************************

#Step 6 - Add friendly column variable names from features
namecol <- grep("-mean\\(\\)|-std\\(\\)",feature$measurement, value=T)
colnames(newmerge) <- c("activity_id",namecol,"subject_id","set","activity")

#verify column mapping by randomly selecting one column
colnames(merged) <- feature$measurement
mean(merged[,"fBodyGyro-mean()-X"])
mean(newmerge[,"fBodyGyro-mean()-X"])

#****************************PART FIVE***********************************

#Step 7 - Create new independent tidy data set with the average of each variable for each activity and each subject

#remove set and actvity_id columns from dataset
cleanmerge <- newmerge[,!(names(newmerge) %in% c("activity_id","set"))]

tidymean <- aggregate(cleanmerge[,!(names(cleanmerge) %in% c("subject_id","activity"))],by=list(cleanmerge$subject_id,cleanmerge$activity),FUN=mean,na.rm=T)
colnames(tidymean)[1:2] <- c("subject_id","activity")

write.table(tidymean,"tidy_mean.txt",row.names=FALSE)
## readtidy <- read.table("tidy_mean.txt",header=T)