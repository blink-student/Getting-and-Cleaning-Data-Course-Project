## run_analysis.R
## Peer-graded Assignment: Getting and Cleaning Data Course Project
## DBoiko 2016-10

library(data.table);
library(plyr);
library(dplyr);

## it is assumed that the working data is already prepared and is in working directory
## but the script can download it and unzip

if (!file.exists("UCI HAR Dataset")) {
 url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 f <- file.path(getwd(), "dataset.zip");
 download.file(url, f);
 unzip ("dataset.zip", exdir = ".")
}

dataDir <- file.path(getwd(), "UCI HAR Dataset");


## Step 1. Merge the training and the test sets to create one data set.

# training data
activityLabels <- read.table(file.path(dataDir,"activity_labels.txt"), header = FALSE);
features <- read.table(file.path(dataDir,"features.txt"), header = FALSE);
subject_train <- read.table(file.path(dataDir,"train","subject_train.txt"), header = FALSE);
x_train <- read.table(file.path(dataDir,"train","x_train.txt"), header = FALSE);
y_train <- read.table(file.path(dataDir,"train","y_train.txt"), header = FALSE);
colnames(activityLabels) <- c("activityId", "activityLabel");
colnames(subject_train) <- "subjectId";
colnames(x_train) <- features[,2]; 
colnames(y_train) <- "activityId";
training_dataset <- cbind(y_train, subject_train, x_train);# merging all training data

# test data
subject_test <- read.table(file.path(dataDir,"test","subject_test.txt"), header = FALSE);
x_test <- read.table(file.path(dataDir,"test","x_test.txt"), header = FALSE);
y_test <- read.table(file.path(dataDir,"test","y_test.txt"), header = FALSE);
colnames(subject_test) <- "subjectId";
colnames(x_test) <- features[,2]; 
colnames(y_test) <- "activityId";
test_dataset <- cbind(y_test, subject_test, x_test);# merging all test data

full_dataset <- rbind(training_dataset, test_dataset);# merging training and test data


## Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 

cl <- colnames(full_dataset); 
full_dataset <- full_dataset[
	(grepl("activity..",cl)
	|grepl("subject..",cl)
	|grepl("-mean..",cl) & !grepl("-meanFreq..",cl) 
	|grepl("-std..",cl))
	];


## Step 3. Uses descriptive activity names to name the activities in the data set

full_dataset <- merge(full_dataset, activityLabels, by="activityId", all.x=TRUE);


## Step 4. Appropriately labels the data set with descriptive variable names.

cl <- colnames(full_dataset); 
for (i in 1:length(cl)) 
{
#cl[i] <- gsub("activityId","activityId",cl[i])
#cl[i] <- gsub("activityLabel","activityLabel",cl[i])
#cl[i] <- gsub("subjectId","subjectId",cl[i])
cl[i] <- gsub("^t","time",cl[i])
cl[i] <- gsub("^f","freq",cl[i])
cl[i] <- gsub("\\(\\)","",cl[i])
cl[i] <- gsub("-mean","Mean",cl[i])
cl[i] <- gsub("-std","StdDev",cl[i])
cl[i] <- gsub("-[Xx]","X",cl[i])
cl[i] <- gsub("-[Yy]","Y",cl[i])
cl[i] <- gsub("-[Zz]","Z",cl[i])
cl[i] <- gsub("[Gg]ravity","Gravity",cl[i])
cl[i] <- gsub("([Bb]ody){1,2}","Body",cl[i])
cl[i] <- gsub("[Gg]yro","Gyroscope",cl[i])
cl[i] <- gsub("[Mm]ag","Magnitude",cl[i])
cl[i] <- gsub("[Aa]cc","Accelerometer",cl[i])
cl[i] <- gsub("[Jj]erk","Jerk",cl[i])
};

colnames(full_dataset) <- cl;


## Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

fdWO  <- full_dataset[,names(full_dataset) != "activityLabel"];# remove activityLabel
tidyDataset <- aggregate(fdWO[,names(fdWO) != c("activityId","subjectId")],by=list(activityId=fdWO$activityId,subjectId = fdWO$subjectId),mean);
tidyDataset <- merge(tidyDataset,activityLabels,by='activityId',all.x=TRUE);# add activityLabel
tidyDataset  <- tidyDataset[,names(tidyDataset) != "activityId"];# remove activityId
#not the most elegant solution :(


write.table(tidyDataset, file = file.path(getwd(),"tidyData.txt"),row.names=FALSE)
