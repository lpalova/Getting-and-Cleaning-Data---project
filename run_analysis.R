# 1. Merge the training and the test sets to create one data set.

library(dplyr)

# Load the activity_labels and features.
activity_labelsDF <- read.table("./UCI\ HAR\ Dataset/activity_labels.txt",
                                col.names=c("activity index","activity")
                                )
feature_labelsDF <- read.table("./UCI\ HAR\ Dataset/features.txt", 
                               col.names = c("feature index", "feature"),
                               colClasses = c("integer", "character")
                               )

# Notice that feature_labelsDF is NOT a unique list of features: some features have multiple indices, 
# e.g., feature.index 303, 317 and 331 all refer to the feature "fBodyAcc-bandsEnergy()-1,8".
# We create a unique list of feature names (we construct a new name from the old one 
# for all duplicates).
feature_labelsDF$feature <- make.names(feature_labelsDF$feature, unique = TRUE)

# Load the test set.
test_setDF <- bind_cols(
        read.table("./UCI\ HAR\ Dataset/test/subject_test.txt", col.names = "subject"), 
        read.table("./UCI\ HAR\ Dataset/test/y_test.txt", col.names = "activity"), 
        read.table("./UCI\ HAR\ Dataset/test/X_test.txt", col.names = as.character(feature_labelsDF$feature) ) 
        )

# Load the train set.
train_setDF <- bind_cols(
        read.table("./UCI\ HAR\ Dataset/train/subject_train.txt", col.names = "subject"),
        read.table("./UCI\ HAR\ Dataset/train/y_train.txt", col.names = "activity"),
        read.table("./UCI\ HAR\ Dataset/train/X_train.txt", col.names = as.character(feature_labelsDF$feature) ) 
        )

# Merge the two sets.
setDF = bind_rows( train_setDF, test_setDF )
# Then remove the test and train sets.
rm(test_setDF)
rm(train_setDF)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
# We select those (setDF) columns whose names contain "std" or "mean". 
# We also keep the first two "subject" and "activity" columns.
selected_setDF <- bind_cols(
        setDF[1:2],
        select(setDF, contains("std", ignore.case = FALSE)),
        select(setDF, contains("mean", ignore.case = FALSE))
        )

# 3. Uses descriptive activity names to name the activities in the data set 
selected_setDF <- mutate(selected_setDF, activity = activity_labelsDF[activity,2])

# 4. Appropriately labels the data set with descriptive variable names
names(selected_setDF)

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject

# Convert the selected set from a data frame (DF) to a "tbl" object.
selected_set_tbl <- tbl_df(selected_setDF)
rm(selected_setDF)

# First, group the data by "subject" and "activity". 
# Then summarize each of the remaining columns via the mean (calculated for each "subject" and "activity" group).
# The second tidy data is stored in a tbl object "set_sum".
set_sum <- selected_set_tbl %>% group_by(subject, activity) %>% summarise_each( funs(mean) )

write.table(set_sum, file = "./set_sum.txt", row.names = FALSE)



