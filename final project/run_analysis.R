## Download the file from the web into the laptop and unzip the files
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "data.zip")
unzip("data/data.zip")

## create data files(file X is the dat file for both training set and test set subjects)
traindata<-read.table("UCI HAR Dataset/train/X_train.txt")
testdata<-read.table("UCI HAR Dataset/test/X_test.txt")
X<-rbind(traindata, testdata)

## creating activity data set (Y text files gives the activity to which the data represents)
act_train_num<-read.table("UCI HAR Dataset/train/y_train.txt")
act_test_num<-read.table("UCI HAR Dataset/test/y_test.txt")
Y<-rbind(act_train_num, act_test_num)

## creating subject data set (subj_text files gives the subject)
sub_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
sub_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
subject<-rbind(sub_train, sub_test)

## removing unwanted or temporary created datasets
rm(act_test_num,act_train_num,sub_test,sub_train,traindata,testdata)

## features list - denotes the lables for the data
f<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
features<-f$V2
rm(f)

## Extracting the measurements on mean and std on each measurement
mean_std<-grep("(mean[^Ff])", features, perl=TRUE)
X<-X[,mean_std]

##  making the data into better readable format 
names(X)<-features[mean_std]
names(X)<-gsub("()","", names(X))

## reading the activity 
act_lab<-read.table("UCI HAR Dataset/activity_labels.txt")
act_lab[,2]=gsub("_", " ", act_lab[,2])
Y[,1]=act_lab[Y[,1],2]
names(Y)<-"activity"
names(subject)<-"Subject"

## Merging the 3 datasets into one data file
merged_data<-cbind(subject, Y, X)

## Writing the data
write.table(merged_data,"result/merged data.txt")

## creating an independent tidy data set with average of each variable for each activity and each subject
avg_data<-aggregate(merged_data, by=list(activities=merged_data$activity, subject=merged_data$Subject), FUN=mean)
avg_data<-avg_data[,!(colnames(avg_data) %in% c("subj", "activity"))]
write.table(avg_data, "result/averaged data.txt")