getting-and-cleaning-data
=========================

Getting and Cleaning Data Project

Unzip the source ( https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ) 
into a folder on your local drive, say "C:\Users\ramkumar.ramagopalan\Desktop\R Source Files\assignment get data"

Place run_analysis.R file under "C:\Users\ramkumar.ramagopalan\Desktop\R Source Files\assignment get data" directory

In RStudio: 1. setwd("C:\Users\ramkumar.ramagopalan\Desktop\R Source Files\assignment get data") 2. source("run_analysis.R")

The latter will run the R script, it will read the dataset and write these files:

Merged_Cleanedup_Data.txt -- 7.95 Mb 
Final_tidy_data.txt -- 220 KB

The script normally runs for ~30 seconds, but the actual run time depends on your system configuration.

Use data <- read.table("Final_tidy_data.txt") to read the latter. 
It is 180x68 because there are 30 subjects and 6 activities, thus "for each activity and each subject" means 30*6=180 rows. 
Note that the provided R script has no assumptions on numbers of records, only on locations of files.
