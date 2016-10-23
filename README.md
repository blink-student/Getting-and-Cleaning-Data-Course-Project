This README file contains additional information about running of the **run_analysis.R** script.  

Note:
* It is assumed that the unzipped folder "UCI HAR Dataset" is already prepared and is in working directory. But there are also a few lines for downloading and unzipping the data.  

Main steps:  

1. Reading of all files to the tables in memory, merging the training and the test sets to one "full_dataset".  

2. With a set of logical vectors on column names of the full_dataset, filtering-out all measurements except for the mean and standard deviation.  

3. Adding a column "activityLabels" with descriptive activity names.  

4. Using patterns to replace some parts in variable names to make them more descriptive.  

5. Aggregating and creating a new tidy data set. Then writing tidyDataset to tidyData.txt file in the working directory.  
