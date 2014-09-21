# Source of data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# This R script does the following:
# 1. Merges the training and the test sets to create one data set.

# setwd("C:/Coursera/Getting and Cleansing Data/Project")

# Read train X_train.txt and store the number of lines in a variable
X_Train <- read.table("train/X_train.txt")

# Storing the number of lines in a variable for later verification
X_Train_Len <- length( readLines("train/X_train.txt")) 

# Read train X_test.txt and store the number of lines in a variable
X_Test <- read.table("test/X_test.txt")

# Storing the number of lines in a variable for later verification
X_Test_Len <- length( readLines("test/X_test.txt"))

# Rowbinding both X_Train and X_Test
X_Train_Test <- rbind(X_Train, X_Test)

#Writing the merged contents into a file for cross verification later.
write.table(X_Train_Test, "merged_Train_Test_data.txt")

# Cross checking happens here
merged_Train_Test_data <- read.table("merged_Train_Test_data.txt")
merged_Train_Test_data_Len <- length( readLines("merged_Train_Test_data.txt"))
merged_Train_Test_data_Len <- merged_Train_Test_data_Len - 1 # To remove the extra header line
Check_Value <- (X_Train_Len + X_Test_Len) - merged_Train_Test_data_Len

# If the value if not equal to 0 then some lines are missed.  Check this out
Check_Value  

# Cleanup activcities
# Remove the file.  This is just to confirm if any lines missed out
unlink("merged_Train_Test_data.txt")

# Time to clean up the variables
rm(X_Train_Len)
rm(X_Test_Len)
rm(merged_Train_Test_data)
rm(merged_Train_Test_data_Len)
rm(Check_Value)

# ---------------------
# Same way merge the subject_train and subject_test files and then cross check the number of lines later
Sub_Train <- read.table("train/subject_train.txt")
Sub_Train_Len <- length(readLines("train/subject_train.txt"))

Sub_Test <- read.table("test/subject_test.txt")
Sub_Test_Len <- length(readLines("test/subject_test.txt"))

Sub_Train_Test <- rbind(Sub_Train, Sub_Test)
write.table(Sub_Train_Test, "merged_Sub_Train_Test_data.txt")

merged_Sub_Train_Test_data <- read.table("merged_Sub_Train_Test_data.txt")
merged_Sub_Train_Test_data_Len <- length( readLines("merged_Sub_Train_Test_data.txt"))
merged_Sub_Train_Test_data_Len <- merged_Sub_Train_Test_data_Len - 1 # To remove the extra header line

Check_Value <- (Sub_Train_Len + Sub_Test_Len) - merged_Sub_Train_Test_data_Len
Check_Value

# Remove the file created
unlink("merged_Sub_Train_Test_data.txt")

# Time to clean up the variables
rm(Sub_Train_Len)
rm(Sub_Test_Len)
rm(merged_Sub_Train_Test_data_Len)

# ---------------------
# Same way merge the y_train and y_test files and then cross check the number of lines later
Y_Train <- read.table("train/y_train.txt")
Y_Train_Len <- length(readLines("train/y_train.txt"))

Y_Test <- read.table("test/y_test.txt")
Y_Test_Len <- length(readLines("test/y_test.txt"))

Y_Train_Test <- rbind(Y_Train, Y_Test)
write.table(Y_Train_Test, "merged_Y_Train_Test_data.txt")

merged_Y_Train_Test_data <- read.table("merged_Y_Train_Test_data.txt")
merged_Y_Train_Test_data_Len <- length( readLines("merged_Y_Train_Test_data.txt"))
merged_Y_Train_Test_data_Len <- merged_Y_Train_Test_data_Len - 1 # To remove the extra header line

Check_Value <- (Y_Train_Len + Y_Test_Len) - merged_Y_Train_Test_data_Len
Check_Value

# Remove the file created
unlink("merged_Y_Train_Test_data.txt")

# Time to clean up the variables
rm(Y_Train_Len)
rm(Y_Test_Len)
rm(merged_Y_Train_Test_data_Len)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Features_Info <- read.table("features.txt")
Required_Features <- grep("-mean\\(\\)|-std\\(\\)", Features_Info[, 2])
X_Train_Test <- X_Train_Test[, Required_Features]
names(X_Train_Test) <- Features_Info[Required_Features, 2]
names(X_Train_Test) <- gsub("\\(|\\)", "", names(X_Train_Test))
names(X_Train_Test) <- tolower(names(X_Train_Test)) 

# 3. Uses descriptive activity names to name the Activities in the data set
Activities <- read.table("activity_labels.txt")
Activities[, 2] = gsub("_", "", tolower(as.character(Activities[, 2]))) # Replace the underscore and change to lowercase
Y_Train_Test[,1] = Activities[Y_Train_Test[,1], 2]
names(Y_Train_Test) <- "activity" # Change the header to activity

# 4. Appropriately labels the data set with descriptive activity names.
names(Sub_Train_Test) <- "subject"
Tidy_Data <- cbind(Sub_Train_Test, Y_Train_Test, X_Train_Test)
write.table(Tidy_Data, "Merged_Cleanedup_Data.txt")

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
Distinct_Subjects = unique(Sub_Train_Test)[,1]
Num_Subjects = length(unique(Sub_Train_Test)[,1])
Num_Activities = length(Activities[,1])
Num_Columns = dim(Tidy_Data)[2]
result = Tidy_Data[1:(Num_Subjects*Num_Activities), ]

row = 1
for (Var_Sub in 1:Num_Subjects) {
	for (Var_Act in 1:Num_Activities) {
		result[row, 1] = Distinct_Subjects[Var_Sub]
		result[row, 2] = Activities[Var_Act, 2]
		tmp <- Tidy_Data[Tidy_Data$subject==Var_Sub & Tidy_Data$activity==Activities[Var_Act, 2], ]
		result[row, 3:Num_Columns] <- colMeans(tmp[, 3:Num_Columns])
		row = row+1
	}
}
write.table(result, "Final_tidy_data.txt")

