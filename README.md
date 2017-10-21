# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset from the link provided into the current working directory. If the dataset already exits then no download takes place.
   
2. Read the activities and features and find out only those features that are related to mean or standard deviation.
   
3. Load the train and test datasets having only the required columns as per point number 2, and then combine both the datasets into a single dataset.
   
4. Clean up the column names so that they are more easily readable and understandable.

5. Find the mean/average of each variable/feature for each subject and activity and store the result in tidy_data.txt file
   



 