---
output: pdf_document
---
# Average Signal Features for Samsung Galaxy S Smartphone


## **Overview**   

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
Here we take data collected from the accelerometers from the Samsung Galaxy S smartphone and create a tidy data set 
with averages of certain smartphone features (mean and standard deviation of time and frequency dependent acceleration).
Please see part 3. for details.

A full description of the data is available at the following site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The input files for the R script can be downloaded here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## **Description of the Experiments**   

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:   
* - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.   
* - Triaxial Angular velocity from the gyroscope.    
* - A 561-feature vector with time and frequency domain variables.    
* - Its activity label.    
* - An identifier of the subject who carried out the experiment.   

Please see detailed description of the experiments in the README.txt and features_info.txt files that 
are included with the dataset (zip file above).

## **Creating a Tidy Data Set**

Here we merge the training and test sets to create one data set. 
We average the time and frequency acceleration signal for each subject and activity and create a tidy data set.
Our output data set includes the subject identifier (integer between 1-30),
the activity label (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING),
and the average signal of the mean and standard deviation of the time and frequency domain variables
(subset of the 561-feature vector) for each activity and subject.
Our final data set has 180 observations (30 subjects x 6 activities) and 81 variables.
The variables are described in *CodeBook.md*.
The analysis is performed by the script *run_analysis.R*.

We perform the following steps in our script:

+ **Merge the training and the test sets to create one data set.**   
We use the *dplyr* package. 
We load the *activity_labels.txt* and *features.txt* files, and
create two data frames that match activities with their corresponding activity indices
and features with their corresponding feature indices, *activity\_labelsDF* and *feature\_labelsDF*, respectively.
We find that the feature names (*feature_labelsDF$feature*) are not unique: some features have multiple indices. 
For example, *feature.index 303*, *317* and *331* all refer to the feature *"fBodyAcc-bandsEnergy()-1,8"*.
We therefore create a unique list of feature names; we construct a new name from the old one for all duplicates.
We load the train and the test sets. The first and second column in both sets correspond to the variables
"subject" and "activity", respectively. Notice that the variable "activity" contains the activity index.
The train and the test set contain the time and frequency domain variables of the 561-feature vector.
Names of these variables are labeled by the feature names listed in *feature\_labelsDF*.
We bind the train and the test sets by rows. The resulting data frame is *setDF*.

+ **Extract only the measurements on the mean and standard deviation for each measurement.**   
We select columns of the *setDF* data frame whose name contain *std* or *mean* character string.
We also include the "subject" and "activity" variables into the new *selected_setDF* data frame.

+ **Use descriptive activity names to name the activities in the data set.**   
We use the activity labels rather than the activity indices to represent values of the *activity* variable.
We look for the name corresponding to an activity index in the *activity_labelsDF* data frame
and replace the index by its label (using the *dplyr* function *mutate*).

+ **Appropriately label the data set with descriptive variable names.**   
We appropriately label the feature variables when we read the trial and the test sets using command
*col.names = as.character(feature_labelsDF$feature)*.
The names of the features correspond to the names listed in *features.txt* 
(up to an implicit formatting; please see the CodeBook.md for details).

+ **Create a second, independent tidy data set with the average of each variable for each activity and each subject.**  
We convert the selected set from a data frame to a *tbl* object.
We *group* the data *by subject* and *activity*. 
Then we calculate the mean of each variable (each column in the set) using the *summarise_each* function 
for each activity and each subject.
We store the result in a new *tbl* object *set\_sum* and export the data to a *txt* file called *set\_sum.txt*.