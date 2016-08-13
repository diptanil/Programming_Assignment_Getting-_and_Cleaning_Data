# read in all the tables

activitylabel <- read.table("activity_labels.txt")
features <- read.table("features.txt")

setwd("train")
trainset <- read.table("X_train.txt")
activitytrain <- read.table("Y_train.txt")
subjecttrain <- read.table("subject_train.txt")

setwd("..")

setwd("test")
testset <- read.table("X_test.txt")
activitytest <- read.table("Y_test.txt")
subjecttest <- read.table("subject_test.txt")

setwd("..")

#merge the train data and test data

acttrain <- full_join(activitytrain, activitylabel, by = c("V1" = "V1"))
acttest <- full_join(activitytest, activitylabel, by = c("V1" = "V1"))

full_train <- cbind(subjecttrain, acttrain$V2, trainset)
names(full_train)[-(1:2)] <- as.character(features$V2)
names(full_train)[1] <- "subject_id"
names(full_train)[2] <- "activity"

full_test <- cbind(subjecttest, acttest$V2, testset)
names(full_test)[-(1:2)] <- as.character(features$V2)
names(full_test)[1] <- "subject_id"
names(full_test)[2] <- "activity"

full <- rbind(full_train, full_test)

#Now getting the columns involving mean and standard deviation

meanstdcol <- grep("mean()|std()", names(full))

# Creaing table of only the mean and the std values

final <- full[,meanstdcol]
final <- cbind(full$subject_id, full$activity, final)
names(final)[1:2] <- c("subject_id", "activity")

colnames(final) <- gsub("[()]", "", colnames(final))

#creating the tidy data frame containing mean

tidyfin <- final %>% group_by(subject_id, activity) %>% summarise_each(funs(mean))

#saving the file in final.txt

write.table(tidyfin, file = "final.txt", row.names = FALSE)