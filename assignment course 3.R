library(dplyr)


#download zip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" , ".\\course3_zip.zip")
unzip("course3_zip.zip")

#read data

subject_test <- read.table(".\\course3_zip\\UCI HAR Dataset\\test\\subject_test.txt")
subject_train <- read.table(".\\course3_zip\\UCI HAR Dataset\\train\\subject_train.txt")

y_train <- read.table(".\\course3_zip\\UCI HAR Dataset\\train\\Y_train.txt")
y_test <- read.table(".\\course3_zip\\UCI HAR Dataset\\test\\Y_test.txt")

x_train <- read.table(".\\course3_zip\\UCI HAR Dataset\\train\\X_train.txt")
x_test <- read.table(".\\course3_zip\\UCI HAR Dataset\\test\\X_test.txt")

variable_names <- read.table(".\\course3_zip\\UCI HAR Dataset\\features.txt")

activity_labels <- read.table(".\\course3_zip\\UCI HAR Dataset\\activity_labels.txt")

#combine test and training set
subject <- rbind(subject_train, subject_test)
y <- rbind(y_train, y_test)
x <- rbind(x_train, x_test)

#Extracts only the measurements on the mean and standard deviation for each measurement.
mean_stdv <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]

# add labels
colnames(y) <- "activity"
summary(y)
y$activity <- as.factor(y$activity)
summary(y)
colnames(x) <- variable_names[mean_stdv[,1],2]

colnames(subject) <- 'volunteer'

# create tidy dataset
tidy_df <- cbind(x, y, subject)
str(tidy_df)
statistics_df <-  tidy_df %>% group_by(activity, volunteer) %>% summarize_each(funs(mean))
write.table(statistics_df, file = "./tidydataset.txt", row.names = FALSE, col.names = TRUE)