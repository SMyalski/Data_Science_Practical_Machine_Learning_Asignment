#Machine Learning Asignment
library(caret)
set.seed(1)

### Download training and test sets and load them

#FILEuRL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
#download.file(FILEuRL,destfile="./data/train.csv")

#FILEuRL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
#download.file(FILEuRL,destfile="./data/test.csv")

testFile <- read.csv('./data/test.csv')
trainFile <- read.csv('./data/train.csv')



#Cleaning data
#Columns 1-7 are irrelevant and there are many columns with NAs
#Column 160 is classe, and we need it

variance <- diag(var(trainFile))
validColumns <- !is.na(variance)
validColumns[1:7] = FALSE
validColumns[160] = TRUE

trainClean <- trainFile[,validColumns]



inTrain = createDataPartition(y = trainClean$classe, p = 0.6, list = FALSE)
trainSet = trainClean[inTrain, ]
testSet = trainClean[-inTrain, ]

modelFit <- train(trainSet$classe ~ ., method='rda', preProcess="pca", data=trainSet)
prediction = predict(modelFit, testSet)
confusionMatrix(prediction, testSet$classe)

TestFileprediction = predict(modelFit, testFile)
#RDA
#[1] B A C A A E D B A A B C B A E E A B B B
