# clean.data
Getting & Cleaning Data Project for Coursera

#Code Explanation

The code is well documented and follows a straight forward flow:

1. Combine the test & train subjects files
2. Combine the test & train X files
3. Combine the test & train y files
4. Read the feature names file and fix them up
5. Read the activity names file
6. Join the y result and the activity names
7. Set the X data frame column names
8. Extract only the mean and std columns
9. cbind all data frames to create the complete data set
10. Convert to a data.table and melt to long format
11. Create summary statistics