## You should create one R script called run_analysis.R that does the following.

library(reshape2)       # It's gonna be neccesary in the last step.

## 1. Merges the training and the test sets to create one data set.

# Read data
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Add column names

names(X_test) <- features[, 2]
names(y_test) <- "idActivity"
names(subject_test) <- "idSubject"
names(X_train) <- features[, 2]
names(y_train) <- "idActivity"
names(subject_train) <- "idSubject"

# Combine data into one data frame
test <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)

finalDS <- rbind(test, train)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std_only <- grepl("mean\\(|std\\(", names(finalDS))
mean_std_only[1:2] <- TRUE

finalDS <- finalDS[, mean_std_only]

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.

## Transform the "idActivity" column, from integer to its names
activity_names <- activity_labels[, 2]
finalDS[, 2] <- activity_names[finalDS[, 2]]

# Rename the column idActivity
names(finalDS)[names(finalDS) == "idActivity"] <- "activity"

## 5. From the data set in step 4, creates a second, independent tidy data set with
##    the average of each variable for each activity and each subject.

meltedDS <-melt(finalDS, id = c("idSubject", "activity"))
tidyDS <- dcast(meltedDS, idSubject + activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidyDS, "./Data/UCI HAR Dataset/tidy.csv", row.names=FALSE)
