# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset files on wearable computing 
2. Loads the features and activities labels
3. Filter the data keeping only data reflecting a mean or standard deviation
4. Loads the training and test datasets
5. Loads the activity and subject data for each dataset, and merges those
   columns with the dataset
6. Merges the training and test datasets together
7. Converts the activity and subject columns into factor while adding the columns names
8. Calculates the mean for each measurement feature
9. Writes the result to the text file 'tidy.txt'.
