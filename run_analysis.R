# Load required library
library(dplyr)

# Check and unzip dataset if necessary
if (!file.exists("UCI HAR Dataset")) { 
  unzip("getdata_projectfiles_UCI HAR Dataset.zip") 
}

# Read feature and activity label information
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Load Test Data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

# Load Train Data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Step 1: Merging the training and test sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

merged_data <- cbind(subject_data, y_data, x_data)

# Step 2: Extract measurements on the mean and standard deviation
tidy_data <- merged_data %>%
  select(subject, code, contains("mean"), contains("std"))

# Step 3: Use descriptive activity names
tidy_data$code <- activities[tidy_data$code, 2]

# Step 4: Label the dataset with descriptive variable names
names(tidy_data)[2] <- "activity"

names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("-mean\\(\\)", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-std\\(\\)", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-freq\\(\\)", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))

# Step 5: Create final tidy dataset with the average of each variable for each activity and each subject
final_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# Export final dataset
write.table(final_data, "FinalData.txt", row.name = FALSE)

# Check structure and preview
str(final_data)
final_data
