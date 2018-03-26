# Assignment for Getting and Cleaning Data Week 4

## The source file is located in run_analysis.R.  The steps which the script executes are as follows:

## Step 1
A folder named "HAR" is created in the current working directory, if none exists. If the Samsung fitness tracker has not already been downloaded, it is downloaded and placed in the "HAR" folder.  The zip file is unzipped to a subfolder called "UCI HAR Dataset".  The file list of the HAR folder is checked.  If no files exist, the above must have failed and the script terminates.

The Subject data is loaded from /train/subject_train.txt and /test/subject_test.txt, rows are combined into a dataframe, and the variable is named "subject".  The Activity data is loaded from /train/y_train.txt and /test/y_test.txt, rows are combined into a dataframe, and the variable is named "activity".

The features (instrument measurements) data is loaded from /train/x_train.txt and /test/x_test.txt, rows are combined into a dataframe, and the variable is named "features".  The feature names are loaded from /features.txt and assigned to the features data frame as the variable names.
The above data frames are collumn bound to a single dataframe called "data_combined_full".

## Step 2
The script searches the feature name list for those which contain "mean" or "std".  The associated variables are then placed in a new dataframe called data_combined_sel along with the "subject" and "activity" variables.

## Step 3
The activity labels are read from the file "activity_labels.txt".  The activity data in the original dataset (represented by integers 1-6) is replaced with a descriptive string.

## Step 4
Several variables in the original dataset which are not tidy exist.  Variables starting with "t", "f", and "BodyBody" have these prefixes replaced with "Time", "Frequency", and "Body".


## Step 5
A separate dataframe titled "tidydata" is created with the average of each variable for each activity and each subject.  This is then saved as "/HAR/tidydata.txt".  The tidydata.txt file is in comma separated value format.
