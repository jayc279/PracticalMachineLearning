# Data Preprocessing  
library(caret)
library(randomForest)

# use read.csv or fread
pml_training <-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
pml_testing <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
trainData <- read.csv(url(pml_training),sep = ",", na.strings = c ("","NA"))
testData <- read.csv(url(pml_testing),sep = ",", na.strings = c ("","NA"))

## Data Clean, and Setup for Analysis  
# Remove first 7 columns since they do not add value to this analysis
trainData <- trainData[, -c(1:7)]
testData <- testData[, -c(1:7)]

## Drop columns with all NA values
trainData <- trainData[, colSums(is.na(trainData)) == 0] 
testData <- testData[, colSums(is.na(testData)) == 0] 

  
library(dplyr)
library(caret)
## convert all 'integer' columns to 'numeric'
trainData <- trainData %>%  mutate_if(is.integer, as.numeric)
testData <- testData   %>% mutate_if(is.integer, as.numeric)

### Slice the data
## Then, we can split the cleaned training set into a pure training data set (70%) and a validation data set (30%). We will use the validation data set to conduct cross validation in future steps.  

set.seed(20211103) # For reproducible purpose
inTrain <- createDataPartition(trainData$classe, p=0.70, list=F)
trainingData <- trainData[inTrain, ]
validationData <- trainData[-inTrain, ]

## Data Modeling
## We fit a predictive model for activity recognition using **Random Forest** algorithm because it automatically selects important variables and is robust to correlated covariates & outliers in general. We will use **5-fold cross validation** when applying the algorithm. 

controlRf <- trainControl(method="cv", 5)
modelRf <- train(classe ~ ., data=trainingData, method="rf", trControl=controlRf, ntree=250)
modelRf

Random Forest 

13737 samples
   52 predictor
    5 classes: 'A', 'B', 'C', 'D', 'E' 

## No pre-processing
## Resampling: Cross-Validated (5 fold) 
## Summary of sample sizes: 10990, 10990, 10989, 10990, 10989 
## Resampling results across tuning parameters:

 ##  mtry  Accuracy   Kappa    
 ##   2    0.9902453  0.9876589
 ##  27    0.9913372  0.9890415
 ##  52    0.9849307  0.9809361

A## ccuracy was used to select the optimal model using the largest value.
## The final value used for the model was mtry = 27.

### Then, we estimate the performance of the model on the validation data set.  
predictRf <- predict(modelRf, validationData)
confMat <- confusionMatrix(as.factor(validationData$classe), predictRf)
confMat$table

## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1672    2    0    0    0
##          B   14 1121    3    1    0
##          C    0    3 1020    3    0
##          D    0    0   11  951    2
##          E    0    1    1    1 1079
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9929          
##                  95% CI : (0.9904, 0.9949)
##     No Information Rate : 0.2865          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.991           
##                                           
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9917   0.9947   0.9855   0.9948   0.9981
## Specificity            0.9995   0.9962   0.9988   0.9974   0.9994
## Pos Pred Value         0.9988   0.9842   0.9942   0.9865   0.9972
## Neg Pred Value         0.9967   0.9987   0.9969   0.9990   0.9996
## Prevalence             0.2865   0.1915   0.1759   0.1624   0.1837
## Detection Rate         0.2841   0.1905   0.1733   0.1616   0.1833
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9956   0.9954   0.9921   0.9961   0.9988

### Accuracy and Prediction  
accuracy <- postResample(predictRf, as.factor(validationData$classe))
accuracy
est_accuracy <- round(accuracy[1], 4)*100

##  Accuracy     Kappa 
## 0.9928632 0.9909707

out_of_sample_error <- round(1 - as.numeric(confusionMatrix(as.factor(validationData$classe), predictRf)$overall[1]), 4) * 100
out_of_sample_error
## 0.007136788
  
## The estimated accuracy of the model is 99.42%  
## The estimated out-of-sample error is 0.71%.  
  
## Predicting for Test Data Set
## Now, we apply the model to the original testing data set downloaded from the data source. We remove the `problem_id` column first.  
result <- predict(modelRf, testData[, -length(names(testData))])
result

## Appendix: Figures  
### Correlation Matrix Visualization   
library(corrplot)
png(file="corrPlot.png")
corrPlot <- cor(trainingData[, -length(names(trainingData))])
corrplot(corrPlot, method="color")
dev.off()

corrPlot <- cor(trainingData[, -length(names(trainingData))])
corrplot(corrPlot, method="color")

### Decision Tree Visualization  
library(rpart)
library(rpart.plot)
png(file="treeModel.png")
treeModel <- rpart(classe ~ ., data=trainingData, method="class")
prp(treeModel) # fast plot
dev.off()

treeModel <- rpart(classe ~ ., data=trainingData, method="class")
prp(treeModel) # fast plot

