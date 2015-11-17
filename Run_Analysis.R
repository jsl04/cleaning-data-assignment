##unzipping the dataset files and reading all the data tables as well as the features and activity labels
library(dplyr)
unzip('UCI HAR Dataset.zip')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
feat <- read.table('UCI HAR Dataset/features.txt')
activities<- read.table('UCI HAR Dataset/activity_labels.txt')
x_train <- read.table('UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
x_test <- read.table('UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
##assigning the column names for subject and activity
colnames(subject_test) <- c('subject')
colnames(y_test) <- c('activity')
colnames(subject_train) <- c('subject')
colnames(y_train) <- c('activity')
##merging the train and test files
train_bind <- cbind(subject_train, x_train, y_train)
test_bind <- cbind(subject_test,y_test,x_test)
data_merged <- rbind(test_bind, train_bind)
##assigning which activities correspond to which subject
data_merged$activity[which(data_merged$activity==1)] <- 'Walking'
data_merged$activity[which(data_merged$activity==2)] <- 'Walking Upstairs'
data_merged$activity[which(data_merged$activity==3)] <- 'Walking Downstairs'
data_merged$activity[which(data_merged$activity==4)] <- 'Sitting'
data_merged$activity[which(data_merged$activity==5)] <- 'Standing'
data_merged$activity[which(data_merged$activity==6)] <- 'Laying'
##taking the mean and standard deviation for each measurement and placing it in a summary data table
group_by_subject<- group_by(data_merged,subject,activity)
average_per_subject<- summarise_each(group_by_subject,funs(mean))
##assigning the correct column names from the features list
colnames(data_merged)[3:563]<- as.character(feat[1:561,2])
colnames(average_per_subject)[3:563]<- as.character(feat[1:561,2])
##writing the combined data set to a tidy table
write.table(average_per_subject,row.names=FALSE,'tidydata.txt')
