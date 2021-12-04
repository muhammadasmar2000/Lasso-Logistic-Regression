#read input data file
GlobalAncestry = read_csv("GlobalAncestry.csv")

#create training and testing data sets
training_regions = c("African", "European", "EastAsian", "Oceanian", "NativeAmerican")
testing_regions = c("Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5")
train = GlobalAncestry %>% filter(ancestry %in% training_regions)
test = GlobalAncestry %>% filter(ancestry %in% testing_regions)

#use glmnet to train a lasso-penalized multinomial regression classifier
lambdas = 10^seq(-3, 3, length.out = 100)
X = train %>% select(-c(ancestry)) %>% as.matrix()
Y = train %>% select(ancestry) %>% as.matrix()
lasso.fit = glmnet(X, Y, family = "multinomial", alpha = 1, lambda = lambdas)

#plots of regression parameter estimates
plot(lasso.fit, xvar = "lambda")

#10 fold cross validation for multinomial logistic regression
lasso.cv = cv.glmnet(X, Y, family = "multinomial", alpha = 1, lambda = lambdas, nfolds = 10)
plot(lasso.cv)
#lambda value for best model
print(lasso.cv$lambda.min)
#lambda value for simplest model not statistically different from best model
print(lasso.cv$lambda.1se)

#simplest statistically significant lasso model (within 1 standard error from best model)
lasso.1se = glmnet(X, Y, family = "multinomial", alpha = 1, lambda = lasso.cv$lambda.1se)

#use model to make predictions for training data set
estProbs = predict(lasso.1se, X, type = "response", s = lasso.cv$lambda.1se)
estClass = predict(lasso.1se, X, type = "class", s = lasso.cv$lambda.1se)
train$prediction = estClass

#print confusion matrix and model accuracy
train %>% select(ancestry, prediction) %>% table()
train %>% summarize(accuracy = mean(prediction == ancestry))
  
#predict ancestry for testing data set
test_features = test %>% select(-c(ancestry))
predictions = predict(lasso.1se, as.matrix(test_features), type = "class", s = lasso.cv$lambda.1se)
  
  
  