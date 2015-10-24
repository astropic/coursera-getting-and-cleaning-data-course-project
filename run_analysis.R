

# ----------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.
# ----------------------------------------------------------------

library(plyr)
library(dplyr)

##
## Alternative code to automaticaly get ALL files, merge and write them on disk.
##
# setwd("test")
# file_test_list <- list.files(pattern = "*.txt", recursive = TRUE, full.names = TRUE)
# 
# setwd(rootDir)
# for (fileTestName in file_test_list){
#   
#   fileTest <- paste0("test/", fileTestName)
#   datafile1 <- read.table(fileTest)
# 
#   fileTrain <- paste0("train/", gsub("test", "train", fileTestName))
#   datafile2 <- read.table(fileTrain)
# 
#   datafile <- rbind(datafile1, datafile2)
# 
#   fileMerge <- paste0("merge/", gsub("test", "merge", fileTestName))
#   write.table(datafile, fileMerge, row.names = FALSE, col.names = FALSE)
#   
# }

# Get "test" tables
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Get "train" tables
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# Merge "test" and "train" tables to "merge" tables
X_merge <- rbind(X_test, X_train)
y_merge <- rbind(y_test, y_train)
subject_merge <- rbind(subject_test, subject_train)



# ------------------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# ------------------------------------------------------------------------------------------

## Optional to get from disk
# X_merge <- read.table("merge/X_merge.txt")

# Get "features" table
features <- read.table("features.txt")

# Extract feature positions with "mean", "Mean", "std" or "Std" as part of their names.
# Ex.: "tBodyAcc-mean()-Z", "fBodyAccJerk-meanFreq()-X", "angle(tBodyAccJerkMean),gravityMean)".
mean_std_features <- grep("(mean|std|Mean|Std)", features[, 2])

# Keep only the selectd features
X_merge <- X_merge[, mean_std_features]



# --------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set.
# --------------------------------------------------------------------------

## Optional to get from disk
# y_merge <- read.table("merge/y_merge.txt")

# Get "activity_labels" table
activities <- read.table("activity_labels.txt")

# Update activity names with descriptive ones
y_merge[, 1] <- activities[y_merge[, 1], 2]



# ---------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.
# ---------------------------------------------------------------------

## Optional to get from disk
# subject_merge <- read.table("merge/subject_merge.txt")

# Update column names with descriptive variable names
colnames(X_merge) <- features[mean_std_features, 2]
colnames(y_merge) <- "activity"
colnames(subject_merge) <- "subject"



# ----------------------------------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each
#    variable for each activity and each subject.
# ----------------------------------------------------------------------------------------------------

# Merge all data
final_merge <- cbind(subject_merge, y_merge, X_merge)

# Calculate the mean by subject and activity, for each data column
average_final_merge <- ddply(final_merge, .(subject, activity), function(x) colMeans(x[, 3:88]))

# Write final table
write.table(average_final_merge, "average_final_merge.txt", row.name=FALSE)


