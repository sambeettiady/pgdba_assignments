#Remove previous objects
rm(list = ls())

#Load packages
library(dplyr)
library(readr)
library(corrplot)
library(car)

#Set working directory
setwd('/home/sambeet/data/')

#Read wine dataset
wine_data = read_csv(file = 'wineTrain.csv')

#Set names to lower case
names(wine_data) = tolower(names(wine_data))

#####Defining new variables here based on analysis below#####
#Quality seems to depend negatively on totalsulphurdioxide and positively on freesulphuroxide with almost
#similar coeffs. Hence, we created a derived variable i.e. trappedsulphurdioxide
wine_data$trappedsulphurdioxide = wine_data$totalsulphurdioxide - wine_data$freesulphurdioxide
#Log transformation of sulphates, makes the histogram normal and increases r-squared
wine_data$sulphates_log = log(wine_data$sulphates)

#Split into test and train
set.seed(23)
intrain = sample(as.numeric(row.names(wine_data)),replace = F,size = 0.7*(nrow(wine_data)))
train = wine_data[intrain,]
test = wine_data[-intrain,]

#Univariate analysis
boxplot(train$totalsulphurdioxide~train$quality)
hist(log1p(train$quality))
summary(wine_data)

#Bivariate analysis
plot(train$totalsulphurdioxide,train$quality)
#Correlation matrix
#Most important variables are alcohol and volatileacidity
corrplot.mixed((cor(train)))
#Shows the correlated variables clustered together
#acidity related variables are highly correlated with each other 
corrplot.mixed(abs(cor(train)),order = 'hclust')
#Mean of variables grouped by quality
summarised_by_level = train %>% group_by(quality) %>% mutate(count = n()) %>% summarise_all(.funs = mean)

#Ran 1st model on full dataset
lmfit = lm(data = train,formula = quality ~ .-trappedsulphurdioxide - sulphates_log)
#Lot of insignificant variables
summary(lmfit)
#Plot shows non-linearity at the extreme fitted values
plot(lmfit)
#High vif for some variables
vif(lmfit)

#Removed variables which were correlated with each other and had low correlation with quality as well as
#insignificant variables
lmfit1 = lm(data = train,formula = quality ~ volatileacidity + chlorides + trappedsulphurdioxide + 
                sulphates_log + alcohol)
#Increased adj.R2
summary(lmfit1)
plot(lmfit1)
#Vif is around 1 for most of the variables
vif(lmfit1)
#Anova shows the same rss for both the models with a difference in 6 degrees of freedom
anova(lmfit,lmfit1)


#Remove highly influential observations using cook's distance
train_outliers_removed = train[cooks.distance(lmfit1) < 4/nrow(train),]
lmfit2 = lm(data = train_outliers_removed,formula = quality ~ volatileacidity + chlorides + 
                trappedsulphurdioxide + sulphates_log + alcohol)
#adj-R2 improves to 0.42 after removing outliers and all variables are significant
summary(lmfit2)
plot(lmfit2)
vif(lmfit2)

#Predict on test dataset
test$predicted_quality_fit2 = predict(object = lmfit2,test)
test$integer_place = floor(test$predicted_quality_fit2)
test$decimal_place = test$predicted_quality_fit2 - test$integer_place

#Accuracy for each iteration of decimal threshold for rounding the predicted values
labels = test$quality
pred_values = test$predicted_quality_fit2
decimal = test$decimal_place
integer = test$integer_place
acc = data.frame(prob_threshold = rep(NA,99),accuracy = rep(NA,99))
for(i in 1:99){
    pred_labels = ifelse(decimal >= i/100,integer + 1,integer)
    z = as.data.frame(table(pred_labels,labels))
    accuracy = 0
    for(j in unique(labels)){
        accuracy = accuracy + ifelse(length(z[z$pred_labels == j & z$labels == j,]$Freq) == 0,0,z[z$pred_labels == j & z$labels == j,]$Freq)
    }
    accuracy = accuracy/3
    acc$prob_threshold[i] = i/100
    acc$accuracy[i] = accuracy
}

plot(acc$prob_threshold,acc$accuracy)
#This analysis gives us that best accuracy is attained for threshold very close to 0.5

#Rounding the predictions
test$predicted_quality = round(test$predicted_quality_fit2,0)

#Contingency table of predicted and actual labels
table(test$quality,test$predicted_quality) 
#Accuracy = 62%
