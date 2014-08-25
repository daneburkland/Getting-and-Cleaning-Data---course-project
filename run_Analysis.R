
#reads train subject and label data, sets column names
train <- read.table("subject_train.txt", header = FALSE, col.names = "subject")
trainLabel <- read.table("y_train.txt", header = FALSE, col.names = "activity")

#reads test subject and label data, sets column names
test <- read.table("subject_test.txt", header = FALSE, col.names = "subject")
testLabel <- read.table("y_test.txt", header = FALSE, col.names = "activity")

#reads variable name file to be used as column names in next step
variables <- read.table("features.txt", header = FALSE)

#reads training and test set data, assigns variable names as column names
trainX <- read.table("X_train.txt", header = FALSE, col.names = variables[,2])
testX <- read.table("X_test.txt", header = FALSE, col.names = variables[,2])

#column binds the three data frames for both train and test
train <- cbind(train, trainLabel, trainX)
test <- cbind(test,testLabel, testX)

#row binds the resulting train and test data frames
df <- rbind(train, test)

#subsets only the subject, activity, mean(x3) and standard deviation(x3) columns
#note that it was my interpretation of instructions to only include the total body mean and total body std columns
df <- df[,1:8]

#reads activity labels, sets 'activity' column as a factor variable, re-labelling with descriptive labels
activityLabels <- read.table("activity_labels.txt")
df$activity <- factor(df$activity, levels = activityLabels[,1], labels = activityLabels[,2])

#improves readability of column names
names(df) <- gsub("tBodyAcc.mean().", "BodyAccelerationMean",names(df))
names(df) <- gsub("tBodyAcc.std().", "BodyAccelerationStd",names(df))

#creates 2nd independent tidy data frame
tidy <- aggregate(df[,3:8], by = list(df$subject,df$activity), FUN = mean, data = df)
tidy <- rename(tidy, c("Group.1" ="subject", "Group.2"="activity"))

#writes txt file
write.table(tidy, file="tidy.txt", row.names=FALSE)
