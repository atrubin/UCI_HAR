training = read.csv("UCI HAR Dataset\\train\\X_train.txt", sep="", header=FALSE)
training[,length(training)+1] = read.csv("UCI HAR Dataset\\train\\Y_train.txt", sep="", header=FALSE)
training[,length(training)+1] = read.csv("UCI HAR Dataset\\train\\subject_train.txt", sep="", header=FALSE)
testing = read.csv("UCI HAR Dataset\\test/X_test.txt", sep="", header=FALSE)
testing[,length(testing)+1] = read.csv("UCI HAR Dataset\\test\\Y_test.txt", sep="", header=FALSE)
testing[,length(testing)+1] = read.csv("UCI HAR Dataset\\test\\subject_test.txt", sep="", header=FALSE)
combined_data = rbind(training, testing)

activity_labels = read.csv("UCI HAR Dataset\\activity_labels.txt", sep="", header=FALSE)

features = read.csv("UCI HAR Dataset\\features.txt", sep="", header=FALSE)

mean_std_cols <- grep(".*-mean.*|.*-std.*", features[,2])

features <- features[mean_std_cols,]

mean_std_cols <- c(mean_std_cols, 562, 563)

combined_data <- combined_data[, mean_std_cols]


colnames(combined_data) <- tolower(c(features$V2, "activity", "subject"))

cur_activity = 1
for (act_label in activity_labels$V2) {
  combined_data$activity <- gsub(cur_activity, act_label, combined_data$activity)
  cur_activity <- cur_activity + 1
}

combined_data$activity <- as.factor(combined_data$activity)
combined_data$subject <- as.factor(combined_data$subject)

tidy = aggregate(combined_data, by=list(activity = combined_data$activity, subject=combined_data$subject), mean)

write.table(tidy, "tidy.txt", sep=" ")
