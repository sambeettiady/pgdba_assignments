import pandas as pd
import numpy as np
from sklearn import svm,model_selection,grid_search,metrics
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

#Tuning - Best cross-validation results were given by linear kernel with C = 10, Polynomial of degree 2 
#had a better cv accuracy but the difference in training and cv accuracy was higher. 
#Hence, some overfitting must have occured. Tf-Idf features had a huge impact as they increased 
#the testing accuracy by 1% compared to same model built on relative frequency features

'''
param_grid = [{'kernel': ['rbf'], 'gamma': [1e-3], 'C': [10]},
                {'kernel': ['linear'], 'C': [10]},
                {'C': [1], 'gamma': [1], 'coef0': [0.1],'degree': [2], 'kernel': ['poly']}]
scoring = ['roc_auc','f1_macro','accuracy']
clf = svm.SVC()
scores = model_selection.GridSearchCV(estimator=clf,param_grid=param_grid,cv=10,n_jobs=-1,refit=False,return_train_score=True,verbose=3)
scores.fit(X_train,Y_train)

train_scores_mean = scores.cv_results_['mean_train_score']
train_scores_std = scores.cv_results_['std_train_score']
test_scores_mean = scores.cv_results_['mean_test_score']
test_scores_std = scores.cv_results_['std_test_score']
lw = 2
param_range = [1,2,3,4]
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
'''

final_model = svm.SVC(C=10,kernel='linear')
final_model.fit(X_train,Y_train)

Y_pred = final_model.predict(X=X_test)
metrics.accuracy_score(y_pred=Y_pred,y_true=Y_test)
metrics.confusion_matrix(y_pred=Y_pred,y_true=Y_test)
metrics.f1_score(y_pred=Y_pred,y_true=Y_test,average='macro')
