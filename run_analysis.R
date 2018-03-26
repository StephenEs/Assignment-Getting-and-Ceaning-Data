## Coursera Getting and Cleaning Data week 4 project 

library(dplyr)


################################################
##  Merge training and test sets into one set ##
##                (Step 1)                    ##
################################################


#Set folder names and file names
filename <- "HAR_data.zip"
rootfolder_path <- file.path("./HAR")
datafolder_path <- file.path(rootfolder_path,"UCI HAR Dataset")
zip_path <- paste(rootfolder_path,"/",filename,sep = "")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"




#####################
##  Data Retrival  ##
#####################

##Check if folder already exists, create if necessary
if(!file.exists(rootfolder_path)) {
      dir.create(rootfolder_path)
      }

##Check if data file already exists, download and create if necessary
if(!file.exists(zip_path)) {
      download.file(fileUrl,destfile = zip_path)
      unzip(zip_path, exdir = rootfolder_path)
}

##Check if data files exist.  If downloading and unzipping has failed, this will return error.
file_list <- list.files(datafolder_path, recursive = TRUE)
if (length(file_list) == 0) {Message("No files found in ", datafolder_path); 
      return() }

#######################################################
## Load the various files into data frames & combine ##
#######################################################


## Combine rows for subject test and training sets,and set the variable name
subject <- rbind(read.table(file.path(datafolder_path, "train/", "subject_train.txt"), header = FALSE),
                 read.table(file.path(datafolder_path, "test/", "subject_test.txt"), header = FALSE))
names(subject)<- c("subject")

## Combine rows for activity test and training sets, and set the variable name
activity <- rbind(read.table(file.path(datafolder_path, "train/", "y_train.txt"), header = FALSE),
                  read.table(file.path(datafolder_path, "test/", "y_test.txt"), header = FALSE))
names(activity)<- c("activity")

## Combine rows for features (the instrument data) for the test and training sets, and set the variable names
features <- rbind(read.table(file.path(datafolder_path, "train/", "X_train.txt"), header = FALSE),
                 read.table(file.path(datafolder_path, "test/", "X_test.txt"), header = FALSE))
feature_names <- read.table(file.path(datafolder_path, "features.txt"), header = FALSE)
feature_names <- feature_names[,2]
names(features) <- as.character(feature_names)

## Combine data into one data frame
data_combined_full <- cbind(subject, activity,features)


#########################################################
## Separate out the variables matching "mean" or "std" ##
## Also include the subject and activity variables     ##
##                  (Step 2)                           ##
#########################################################

feature_name_list <- feature_names[grepl("(mean|std)\\(\\)",feature_names)]
col_select <- c("subject", "activity", as.character(feature_name_list))
data_combined_sel <- data_combined_full[,col_select]


#########################################################
##    Uses descriptive activity names to name the      ##
##           activities in the data set                ##
##                  (Step 3)                           ##
#########################################################

act_labels <- read.table(file.path(datafolder_path, "activity_labels.txt"),header = FALSE)[,2]
data_combined_sel$activity <- factor(data_combined_sel$activity, labels = act_labels)


#########################################################
##    Uses descriptive activity names to name the      ##
##           activities in the data set                ##
##                  (Step 4)                           ##
#########################################################

#replace too-short abbreviations with something more easilly understood
names(data_combined_sel)<-gsub("^t", "Time", names(data_combined_sel))
names(data_combined_sel)<-gsub("^f", "Frequency", names(data_combined_sel))
names(data_combined_sel)<-gsub("BodyBody", "Body", names(data_combined_sel))


#########################################################
## Create a second, independent tidy data set with the ##        
## average of each variable for each activity and      ##
##                each subject.                        ##
##                  (Step 5)                           ##
#########################################################

final_data <- aggregate(. ~subject + activity, data_combined_sel, mean)
final_data <- final_data[order(final_data$subject,final_data$activity),]
write.table(final_data, file = file.path(rootfolder_path,"tidydata.txt"),row.name=FALSE, sep = ',')

