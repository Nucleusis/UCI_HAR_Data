# Prepares tidy data form UCI HAR Dataset according to coursera's course "Getting and cleaning data"

# getting data
if (!file.exists("./coursera")) {dir.create("./coursera")}
destname <- "./getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(destname)){
  message("Downloading data...")
  fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = destname, method = "auto")
}
unzip(destname, exdir = "./coursera")

# reading data sets and other files
data_path <- "./coursera/UCI HAR Dataset"
data_sets <- c("test" = list(1), "train" = list(1))
message("Reading files:")
print("features.txt")
features <- read.table(paste(data_path, "features.txt", sep = "/"))[,2]
features <- gsub("[()[:blank:]]", "", features) # remove '(' and ')' and 'space'
features <- gsub("[[:punct:]]", "_", features) # replace special characters with '_' for valid variable names
print("activity_labels.txt")
activity_labels <- read.table(paste(data_path, "activity_labels.txt", sep = "/")) # names of the activities in the data set

for (set_name in c("test", "train")) {
  file_path <- paste(data_path, set_name, sep = "/")
  data_sets[[set_name]] <- list("y" = data.frame(), "subject" = data.frame(), "X" = data.frame())
  for (i in c("y", "subject", "X")) {
    file_name <- paste(set_name, "txt", sep = ".")
    file_name <- paste(i, file_name, sep = "_")
    print(file_name)
    data_sets[[set_name]][[i]] <- read.table(paste(file_path, file_name, sep = "/"))
    # Appropriately labels the data set with descriptive variable names
    if (i == "X") {
      colnames(data_sets[[set_name]][[i]]) <- features
    } else {colnames(data_sets[[set_name]][[i]]) <- i}    
  }
  # merges the data sets
  data_sets[[set_name]] <- cbind(data_sets[[set_name]][["y"]], data_sets[[set_name]][["subject"]], data_sets[[set_name]][["X"]])
  data_sets[[set_name]] <- cbind("set" = set_name, data_sets[[set_name]])
}
message("Processing...")
# merges the text and train data sets
data_all <- rbind(data_sets$test, data_sets$train)
rm(data_sets)

# Extracts only the measurements on the mean and standard deviation for each measurement
data_names <- names(data_all)[(grepl(pattern = "mean", names(data_all)) & !grepl(pattern = "meanFreq", names(data_all))) 
                              | grepl(pattern = "std", names(data_all))]
data_mean_std <- data_all[c("set", "subject", "y", data_names)]
rm(data_all)

# Uses descriptive activity names to name the activities in the data set
colnames(activity_labels) <- c("y", "activity")
data_tidy <- merge(activity_labels, data_mean_std, by = "y")
rm(data_mean_std)
data_tidy <- within(data_tidy, rm(y))
View(data_tidy)

# creates a second, independent tidy data set with the average of each variable for each activity and each subject
  # creates empty data_average
data_average <- as.data.frame(data_tidy[FALSE,])
data_average <- within(data_average, rm(set))
data_groups <- merge(data.frame("activity" = activity_labels$activity), data.frame("subject" = order(unique(data_tidy$subject))))
data_average <- merge(data_groups, data_average, all = TRUE)
rm(data_groups)
rm(activity_labels)
  # fullfills data_average with means
data_average[data_names] <- lapply(data_tidy[data_names], 
                                   function(data_col) lapply(1:nrow(data_average), 
                                            function(row_ind) mean(data_col[data_tidy$subject == data_average$subject[row_ind] & data_tidy$activity == data_average$activity[row_ind]])))
View(data_average)
message("Done")

# creating file with data_average
file_result = "./coursera/data_average.txt"
data_average[data_names] <- lapply(data_average[data_names], as.numeric)
write.table(data_average, file_result, row.name=FALSE)
message("Result in file:")
print(file_result)

# possible cleaning and testing
#rm(data_tidy)
#rm(data_average)
#unlink(destname)         # removes file 'getdata_projectfiles_UCI HAR Dataset.zip'
#unlink(data_path, recursive = TRUE)        # removes directory 'UCI HAR Dataset'
#View(read.table("./coursera/data_average.txt", header = TRUE))
