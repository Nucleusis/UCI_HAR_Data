# UCI_HAR_Data
Data analysis of UCI HAR Dataset. Course "Getting and cleaning data" on Coursera

Script 'run_analysis.R': cleans up  and processes the data.
1) Script checked data in working directory, downloads it as appropriate, unzip into 'coursera' folder.
2) Reads files "features.txt", "activity_labels.txt", "y_test.txt", "subject_test.txt", "X_test.txt", "y_train.txt", "subject_train.txt", "X_train.txt".  Spaces and such special symbols as '(' and ')' were removed from original features.txt, other special symbols were replaced with '_' to produce valid names of variables. Merges all data sets, appropriately labels the data set with descriptive variable names.
3) Extracts only the measurements on the mean and standard deviation for each measurement.
4) Uses descriptive activity names to name the activities in the data set.
5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. Creates 'data_avarage.txt' file with this data set
