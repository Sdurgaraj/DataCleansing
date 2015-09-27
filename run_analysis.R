# Program - run_analysis.R
# Date Written - 26.09.2015

#Check Data folder available, if not create new directory name it data
if (!file.exists("./CourseData"))
{
  dir.create("./CourseData")
}

#Download Dataset and store zip in Data folde
#fileUrl <- "https:\\d396qusza40orc.cloudfront.net\\getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip?accessType=DOWNLOAD"
#download.file(fileUrl,destfile="./CourseData/Dataset.zip",method="curl")

###Unzip DataSet to /data directory
#unzip(zipfile="./CourseData/Dataset.zip",exdir="./CourseData")

filesPath <- "C:\\Users\\viswak\\Documents\\CourseData\\UCI HAR Dataset"

#Read train data 
Trainsubdata  <- tbl_df(read.table(normalizePath(file.path(filesPath, "train", "subject_train.txt"))))
Trainactdata  <- tbl_df(read.table(normalizePath(file.path(filesPath, "train", "Y_train.txt"))))
Traindata     <- tbl_df(read.table(normalizePath(file.path(filesPath, "train", "X_train.txt" ))))


# Read test data files
Testsubdata   <- tbl_df(read.table(normalizePath(file.path(filesPath, "test" , "subject_test.txt"))))
Testactdata   <- tbl_df(read.table(normalizePath(file.path(filesPath, "test" , "Y_test.txt"))))
Testdata      <- tbl_df(read.table(normalizePath(file.path(filesPath, "test" , "X_test.txt"))))


#Combine subject, activity and data files
subjectdata   <- rbind(Trainsubdata, Testsubdata)
activitydata  <- rbind(Trainactdata, Testactdata)
TotalData     <- rbind(Traindata, Testdata)

#Rename labels for subject and activity datasets
colnames(subjectdata) <- c("subject")
colnames(activitydata) <- c("activityNum")

#Read feature and activity column names
datafeatures  <- tbl_df(read.table(normalizePath(file.path(filesPath,"features.txt"))))
datactivity   <- tbl_df(read.table(normalizePath(file.path(filesPath,"activity_labels.txt"))))

colnames(datafeatures) <- c("featureNum", "featureName")
colnames(TotalData) <- datafeatures$featureName
colnames(datactivity) <- c("activityNum","activityName")

#Merge all columns from subject, activity into Final dataset

subact <- cbind(subjectdata,activitydata)
finaldata <- cbind(subact, TotalData)


#Subset data containing subject, Activity, mean and std
finaldata <- finaldata[ !duplicated(names(finaldata)) ]
finaldata1 <- select(finaldata, contains("subject"), contains("activityNum"), contains("mean"), contains("std"))


finaldata2 <- merge(datactivity, finaldata1 , by="activityNum", all.x=TRUE)
finaldata2$activityName <- as.character(finaldata2$activityName)

## create finaltable with variable means sorted by subject and Activity
dataAggr<- aggregate(. ~ subject - activityName, data = finaldata2, mean) 
finaldata3<- tbl_df(arrange(dataAggr,subject,activityName))


write.table(finaldata3, "TidyData.txt", row.name=FALSE)










