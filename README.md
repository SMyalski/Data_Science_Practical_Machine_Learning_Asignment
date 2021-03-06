# Practical Machine Learning - Asignment
Asignment project for Practical Machine Learning Course

I will shortly explain here how did I build model fit and estimated "classe" parameter for test data.
To do this I will use code and comment certain blocks.

First I am loading libraries and set seed
```
library(caret)
set.seed(1)
```

Then I am downloading train and test files and load them into R
```
FILEuRL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(FILEuRL,destfile="./data/train.csv")
FILEuRL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(FILEuRL,destfile="./data/test.csv")

testFile <- read.csv('./data/test.csv')
trainFile <- read.csv('./data/train.csv')
```

Then I am limiting data set to relevant columns to make fitting faster. To do this I remove zero variance columns, as well as first 7 columns containing irrelevant data (not from sensors). Finally I prepare trainClean data.
```
#Cleaning data
#Columns 1-7 are irrelevant and there are many columns with NAs
#Column 160 is classe, and we need it

variance <- diag(var(trainFile))
validColumns <- !is.na(variance)
validColumns[1:7] = FALSE
validColumns[160] = TRUE

trainClean <- trainFile[,validColumns]
```

To be able to estimate accuracy, in and out of sample errors I needed a validiation set. Therefore I split data into 2 partitions: testSet and trainSet to be able to check different algorithms:
```
inTrain = createDataPartition(y = trainClean$classe, p = 0.6, list = FALSE)
trainSet = trainClean[inTrain, ]
testSet = trainClean[-inTrain, ]
```


I run analysis. I tested this step with different algorithms, some of them producing poor results and others taking too long to finish - with the one selected it was resonable. 
Alorithms I tested were rpart, treebag, bagFDA, bagEarth, glm. For each succesful calculations I was checking confusion matrix both for train and test set. Finally I selected random forest as alghoritm most suitable among tested ones for this particular tast.


On my laptop it took about 2h to finish and results were satisfactory: 97% Accuracy. Probably it might be better with some other alghoritm but it took too long to compute and I did not tested all.
```
modelFit <- train(trainSet$classe ~ ., method='rf', preProcess="pca", data=trainSet)
prediction = predict(modelFit, testSet)
confusionMatrix(prediction, testSet$classe)
```

To estimate out of sample error I checked two sets of result - for test set and for train set.
Confusion Matrix for test set:
```
          Reference
Prediction    A    B    C    D    E
         A 2198   38    3    0    2
         B    9 1457   15    1    7
         C   12   23 1331   69   17
         D    6    0   18 1215   12
         E    7    0    1    1 1404

Overall Statistics
                                         
               Accuracy : 0.9693         
                 95% CI : (0.9652, 0.973)
    No Information Rate : 0.2845         
    P-Value [Acc > NIR] : < 2.2e-16      
                                         
                  Kappa : 0.9611         
 Mcnemar's Test P-Value : 4.996e-16      

Statistics by Class:

                     Class: A Class: B Class: C Class: D Class: E
Sensitivity            0.9848   0.9598   0.9730   0.9448   0.9736
Specificity            0.9923   0.9949   0.9813   0.9945   0.9986
Pos Pred Value         0.9808   0.9785   0.9167   0.9712   0.9936
Neg Pred Value         0.9939   0.9904   0.9942   0.9892   0.9941
Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
Detection Rate         0.2801   0.1857   0.1696   0.1549   0.1789
Detection Prevalence   0.2856   0.1898   0.1851   0.1594   0.1801
Balanced Accuracy      0.9886   0.9774   0.9771   0.9697   0.9861
```

And for train set:

```
Confusion Matrix and Statistics

          Reference
Prediction    A    B    C    D    E
         A 3348    0    0    0    0
         B    0 2279    0    0    0
         C    0    0 2054    0    0
         D    0    0    0 1930    0
         E    0    0    0    0 2165

Overall Statistics
                                     
               Accuracy : 1          
                 95% CI : (0.9997, 1)
    No Information Rate : 0.2843     
    P-Value [Acc > NIR] : < 2.2e-16  
                                     
                  Kappa : 1          
 Mcnemar's Test P-Value : NA         

Statistics by Class:

                     Class: A Class: B Class: C Class: D Class: E
Sensitivity            1.0000   1.0000   1.0000   1.0000   1.0000
Specificity            1.0000   1.0000   1.0000   1.0000   1.0000
Pos Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
Neg Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
Prevalence             0.2843   0.1935   0.1744   0.1639   0.1838
Detection Rate         0.2843   0.1935   0.1744   0.1639   0.1838
Detection Prevalence   0.2843   0.1935   0.1744   0.1639   0.1838
Balanced Accuracy      1.0000   1.0000   1.0000   1.0000   1.0000
```

There is 100% accuracy for train set and 97% for test set.
Comparison of in sample error for train set and out of sample error for test test might suggest the model is overfitting to the data. There are several methods to limit such behaviour, which can be applied, but due to time constraints I will not be testing them in this excercise.



Finally I applied model fit to test file:
```
TestFileprediction = predict(modelFit, testFile)
```
and aquired results shown below:
```
[1] B A C A A E D B A A B C B A E E A B B B
```
After uploading results to coursera I found out one answer was wrong, which gives 95% of accuracy, roughly similar to train set.
