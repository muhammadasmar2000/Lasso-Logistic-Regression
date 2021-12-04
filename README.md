# Lasso-Logistic-Regression
A csv input file is read in the R script and contains one feature called "ancestry" that is determined from about 9000 other features. 

In this project, I have trained a lasso-penalized multinomial logistic regression model after splitting the data into a training and testing data set. 
The training data are the observations that contain ancestry that is either African, European, East Asian, Oceanian, and Native American. The testing data is are the observations in the data that are five unknown ancestry, but the 9000 features used to predict the ancestry are known. 

After the model is trained, it is then validated using ten-fold cross validation to find the lambda values that correspond to the best model and the simplest model that is within one stadard error from the best model. The simplest statistically significant model is used to make predictions for observations in the training data to see the probabilities that the observation belongs to its class. 

A confusion matrix and model accuracy is then printed. Lastly, the simplest statistically significant model is used to make prediction on the testing data to find out what ancestry the unknown data samples belong.
