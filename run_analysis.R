library(dplyr)
library(reshape2)
##Assume UCI HAR Dataset folder is your starting wd for this project
activity_labels<-read.table("activity_labels.txt", header=FALSE)
features<-read.table("features.txt", header=FALSE)
setwd("train") ##I'm aware changing your wd is not good practice
subject_train<-read.table("subject_train.txt")
x_train<-read.table("x_train.txt")
y_train<-read.table("y_train.txt")
setwd("../test") ##I'm aware changing your wd is not good practice
y_test<-read.table("y_test.txt")
x_test<-read.table("x_test.txt")
subject_test<-read.table("subject_test.txt")
x_total<-rbind(x_test, x_train)
y_total<-rbind(y_test, y_train)
y_total<-mutate(y_total,activity=activity_labels[y_total$V1,2],V1=NULL)##Adding the correct activities labels
subject_total<-rbind(subject_test,subject_train)
bigtable<-cbind(subject_total,y_total,x_total)##Creating a table with all the data
colnames(bigtable)[3:ncol(bigtable)]<-features$V2 ##Giving the features their ranme
colnames(bigtable)[1]<-"subject" ##Giving column subject its name
bigtable2<-select(bigtable,subject,activity,contains("mean"),contains("std")) ##Selecting only features 
                                                                              ##with mean and std
big3<-melt(bigtable2,id=c("subject","activity")) ##Converting each feature in a new variable
big_mean<-ddply(big3,.(subject,activity,variable),summarise,mean=mean(value)) ##Summarizing data as requested
write.table(big_mean,file="tidydata.txt",row.names = FALSE)