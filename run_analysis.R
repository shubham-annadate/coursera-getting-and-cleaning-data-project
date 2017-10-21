library(tidyverse)

# Setting the destination file name for download

file_name <- "project_dataset.zip"

# If file is not downloaded yet then download the file

if(!file.exists(file_name)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, file_name, method = "curl")
}

# Setting the name of the unzipped file

unzipped_file_name <- "UCI HAR Dataset"

# If unzipped file does not exist then unzip the zip file 

if(!file.exists(unzipped_file_name)){
  unzip(file_name)
}

# Reading activities and features

activities <- read.table(paste0(unzipped_file_name,"/activity_labels.txt"))
features <- read.table(paste0(unzipped_file_name,"/features.txt"))


# Getting indices of only the required features

required_feature_indices <- grep(".*[m|M]ean.*|.*std.*", features[,2])
required_features <- as.character(features[required_feature_indices, 2])

# Loading the training and testing data

# Train data
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")[required_feature_indices]
train_activities <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_df <- cbind(train_subjects, train_activities, train_data)

# Test data
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")[required_feature_indices]
test_activities <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_df <- cbind(test_subjects, test_activities, test_data)

# Merging the two data sets together

complete_df <- rbind(train_df, test_df)

# Give appropriate labels to the columns 

colnames(complete_df) <- c("subject", "activity", required_features)

# Cleaning up column names

col_names <- colnames(complete_df)

col_names <- gsub("[\\(\\)-]", "", col_names)
col_names <- gsub("^f", "frequencyDomain", col_names)
col_names <- gsub("^t", "timeDomain", col_names)
col_names <- gsub("Acc", "Accelerometer", col_names)
col_names <- gsub("Gyro", "Gyroscope", col_names)
col_names <- gsub("Mag", "Magnitude", col_names)
col_names <- gsub("Freq", "Frequency", col_names)
col_names <- gsub("mean", "Mean", col_names)
col_names <- gsub("std", "StandardDeviation", col_names)
col_names <- gsub("BodyBody", "Body", col_names)

# Use new labels as column names
colnames(complete_df) <- col_names


# Finding average of each variable for each activity and subject

gathered_df <- gather(complete_df, key = "metric", value = "measure" , -(subject:activity))

data_means <- gathered_df %>% 
  group_by(subject, activity, metric) %>% 
  summarise(
    mean = mean(measure)
  )

# Writing data into tidy_data.txt file
write.table(data_means, "tidy_data.txt", row.names = FALSE, quote = FALSE)
