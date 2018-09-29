import pandas as pd
import numpy as np
from sklearn import tree,ensemble,model_selection,grid_search,metrics
import os
import matplotlib.pyplot as plt

os.chdir('/home/sambeet/data/cds assignments/')

spam_data = pd.read_csv('smsdata_transformed_new.csv')

spam_data.head()
spam_data.columns
spam_data.drop(['Unnamed: 0','sms'],inplace=True,axis=1)

Y = spam_data['label']
X = spam_data[[column for column in spam_data.columns if column!= 'label']]
X.columns = [column + '_feature' for column in X.columns]

X_train, X_test, Y_train, Y_test = model_selection.train_test_split(X,Y,test_size = 0.3, random_state = 37)

#Grid Search with 5-fold cv for parameter tuning of different tree classifiers
#Best parameters were then used to build the final classifier
param_grid = [{'n_estimators':[350],'max_features': ['sqrt'],'max_depth': [50],
                'min_samples_split': [6],'min_samples_leaf': [1],'max_leaf_nodes': [None],
                'min_impurity_split': [0.001]}]
scoring = ['accuracy']
#clf = tree.DecisionTreeClassifier()
#base = tree.DecisionTreeClassifier(criterion = 'gini',max_depth = None,min_samples_split = 2,min_samples_leaf = 1,
#                max_features = None,max_leaf_nodes = None)
clf = ensemble.RandomForestClassifier(random_state=37)
scores = model_selection.GridSearchCV(estimator=clf,param_grid=param_grid,cv=5,n_jobs=-1,refit=False,return_train_score=True,verbose=3)
scores.fit(X_train,Y_train)

tune_result = pd.DataFrame(np.column_stack([scores.cv_results_['param_max_features'],
                                            scores.cv_results_['mean_test_score'],scores.cv_results_['std_test_score']]),
                            columns=['param', 'mean_score', 'std_score'])
tune_result.loc[tune_result['param'].isnull(),'param'] = 'default'
tune_result.groupby(['param']).sum()/(tune_result.shape[0]/len(np.unique(tune_result['param'])))

train_scores_mean = scores.cv_results_['mean_train_score']
train_scores_std = scores.cv_results_['std_train_score']
test_scores_mean = scores.cv_results_['mean_test_score']
test_scores_std = scores.cv_results_['std_test_score']
lw = 2
param_range = [3,5,10,20,50,75,100,150,200,250,300,1000]
plt.figure().set_size_inches(8, 6)
plt.semilogx(param_range, train_scores_mean, label="Training score",
             color="darkorange", lw=lw)
plt.fill_between(param_range, train_scores_mean - train_scores_std,
                 train_scores_mean + train_scores_std, alpha=0.2,
                 color="darkorange", lw=lw)
plt.semilogx(param_range, test_scores_mean, label="Cross-validation score",
             color="navy", lw=lw)
plt.fill_between(param_range, test_scores_mean - test_scores_std,
                 test_scores_mean + test_scores_std, alpha=0.2,
                 color="navy", lw=lw)
plt.show()

#Decision Tree Classifier - 98.0% Accuracy
final_model_tree = tree.DecisionTreeClassifier(criterion = 'gini',max_depth = 10,min_samples_split = 2,min_samples_leaf = 1,
                max_features = None, random_state = 37,max_leaf_nodes = None)
final_model_tree.fit(X_train,Y_train)

Y_pred = final_model_tree.predict(X=X_test)
metrics.accuracy_score(y_pred=Y_pred,y_true=Y_test)
metrics.confusion_matrix(y_pred=Y_pred,y_true=Y_test)
metrics.f1_score(y_pred=Y_pred,y_true=Y_test,average='macro')

#Bagging Classifier - 98.0% Accuracy
#Doesn't improve over the pruned decision tree as it already has a high accuracy and we are not 
#tinkering with the max features. Hence, the base classifiers have variance only based on bootstrapping
base = tree.DecisionTreeClassifier(max_depth=20,min_samples_split=32,min_samples_leaf=1)
final_model_bagging = ensemble.BaggingClassifier(base_estimator=base,oob_score=True,n_estimators=100,random_state=3737,verbose=1,n_jobs=-1)
final_model_bagging.fit(X_train,Y_train)

Y_pred = final_model_bagging.predict(X=X_test)
metrics.accuracy_score(y_pred=Y_pred,y_true=Y_test)
metrics.confusion_matrix(y_pred=Y_pred,y_true=Y_test)
metrics.f1_score(y_pred=Y_pred,y_true=Y_test,average='macro')

#Random Forest Classifier - 98.3% Accuracy
final_model_rf = ensemble.RandomForestClassifier(n_estimators=350,max_features='sqrt',max_depth=50,
                                                 min_samples_split=6,min_samples_leaf=1,max_leaf_nodes=None,
                                                 min_impurity_split =0.001,n_jobs=-1,random_state=37)
final_model_rf.fit(X_train,Y_train)

Y_pred = final_model_rf.predict(X=X_test)
metrics.accuracy_score(y_pred=Y_pred,y_true=Y_test)
metrics.confusion_matrix(y_pred=Y_pred,y_true=Y_test)
metrics.f1_score(y_pred=Y_pred,y_true=Y_test,average='macro')

#Gradient Boosting Classifier - 98.7% Accuracy
final_model_boosting = ensemble.gradient_boosting.GradientBoostingClassifier(learning_rate=0.1,
                            n_estimators=300,max_depth=3,min_samples_split=32,subsample=1,
                            min_samples_leaf=15,max_features=0.7,verbose=1,random_state=37)
final_model_boosting.fit(X_train,Y_train)

Y_pred = final_model_boosting.predict(X=X_test)
metrics.accuracy_score(y_pred=Y_pred,y_true=Y_test)
metrics.confusion_matrix(y_pred=Y_pred,y_true=Y_test)
metrics.f1_score(y_pred=Y_pred,y_true=Y_test,average='macro')
