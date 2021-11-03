## Executive Summary
Goal of this project is to use [dataset](http://groupware.les.inf.puc-rio.br/har) from accelerometers on the belt, forearm, arm, and dumbell of 6 participants quantify how much of a particular activity they do correctly and incorrectly, using the 'classe' variable.

Create a report describing how you built your model, and how you used cross validation.

Questions to answer:
1. what you think the expected out of sample error is?
2. Why you made the choices you did.
3. Prediction model to predict 20 different test cases - test set.

The five different 'classe' factors in this dataset are:
-- Exactly according to the specification (Class A)
-- Throwing the elbows to the front (Class B)
-- Lifting the dumbbell only halfway (Class C)
-- Lowering the dumbbell only halfway (Class D)
-- Throwing the hips to the front (Class E)

For more details, please read the section on [Weight Lifting Exercise Dataset](http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har)

## Data Preprocessing
1. Load Required libraries
2. Read CSV files
3. Remove first 7 columns since they do not add value to this analysis
4. Convert columns with all NAs to 0s
5. Convert all 'integer' columns to 'numeric'
6. Split training data set (70%) and a validation data set (30%).
7. Use the validation data set to conduct cross validation in future steps.
## Data Modeling
1. We fit a predictive model for activity recognition using **Random Forest** algorithm because it automatically selects important variables and is robust to correlated covariates & outliers in general.
2. We will use **5-fold cross validation** when applying the algorithm.
3. We estimate the performance of the model on the validation data set.

### Accuracy and Prediction
-- The estimated accuracy of the model is  **99.28%**
-- The estimated out-of-sample error is **0.71%**

Predicted Result on Test Data:
-- [1] B A B A A E D B A A B C B A E E A B B B
--Levels: A B C D E

## Citation
Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. [Qualitative Activity Recognition of Weight Lifting Exercises](http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/work.jsf?p1=11201). Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.
