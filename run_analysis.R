### I start by importing dplyr
library(dplyr)

### Filepaths to the relevant files, pre supposing the (unzipped) dataset is in the working directory
### The dataset "as delivered" is split up into 4 pieces; the test and trainig data are each split into measurement data,
### labels (what activity was performed during a given measurement) and subject (who performed the activity). The descriptive variable names
### and activity labels are also split off into the features.txt file and will have to be reapplied to the dataset.  
trainDataPath <- "./UCI HAR Dataset/train/X_train.txt"
trainLabelsPath <- "./UCI HAR Dataset/train/y_train.txt"
trainSubjectPath <- "./UCI HAR Dataset/train/subject_train.txt"

testDataPath <- "./UCI HAR Dataset/test/X_test.txt"
testLabelsPath <- "./UCI HAR Dataset/test/y_test.txt"
testSubjectPath <- "./UCI HAR Dataset/test/subject_test.txt"

featuresPath <- "./UCI HAR Dataset/features.txt"
activitiesPath <- "./UCI HAR Dataset/activity_labels.txt"

### Reading and merging the training and testing sets, as well as loading the features and activities
rawData <- rbind(read.table(trainDataPath), read.table(testDataPath))
labels <- rbind(read.table(trainLabelsPath), read.table(testLabelsPath))
subjects <- rbind(read.table(trainSubjectPath), read.table(testSubjectPath))
features <- read.table(featuresPath)
activities <- read.table(activitiesPath)

### I switch the numeric variable names to the descriptive ones from the features.txt file
names(rawData) <- features$V2

### I extract the columns with mean and standard deviation data using a regular expression. 
mean_or_std <- grepl("mean\\()|std\\()", names(rawData))
data <- rawData[,mean_or_std]
data %>% mutate_if(is.character, as.numeric)
### I convert the labels from numeric to descriptive, and create a column in data for the activity being measured
descriptiveLabels <- activities[labels$V1,]$V2
data$activity <- descriptiveLabels

### Before making the data set for step 5 I add a column to data for the subject and 
### reorder the column order so that activity and subject become columns 1 and 2
data$subject <- subjects$V1
data <- data[,c(67,68,1:66)]

###Finally, I make the step5 data set where col1 = subject, col2 = activity and 
###the rest of cols 3:68 is the mean for the subject doing the given activity. This data set is then saved as step5.txt
step5 <- aggregate(data[3:68], list(subject = data$subject, activity = data$activity), mean)
write.table(step5, file="step5.txt", row.names = FALSE) ### We were told to set row.names = FALSE in the submissions
write.table(names(step5), file="features.txt", row.names = FALSE)
