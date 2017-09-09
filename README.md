# CleaningDataProject

### Matt Ostberg 9/8/2017
This takes the datasets supplied from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Joins them, cleans them up and extracts the mean, std dev for each activity
and summarizes the variables by subject/activity pair to give the mean

Step 1 read in all the files assuming base directory has the unzipped file/dir in it 

Step 2 Join the files together

an assumption here is the subjects and activities are in the same order
if they're not, the dataset is unusable anyway
so merge the files by adding the subject column to test and train

Step 3 use the features file to give the columns names. Again assuming the
structure of the files is the same, since they have to be in order to be usable

Step 4 make the test and train files complete by binding

join the test and training files together. They have the same column names now
so we can just jam them together and let rbind figure it out

Step 5 throw away the columns that aren't the labels activity/subject
or the mean/std columns

Step 6 use dplyr to group and summarize (summarise) the data for each column
this works because I group by activityname, and the average of the activity 
number for that activity is the activity number itself.
