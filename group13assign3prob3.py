import pandas as pd
import numpy as np
from sklearn import svm,model_selection,grid_search,metrics
from sklearn.decomposition import PCA
import os
import matplotlib.pyplot as plt
from sklearn.ensemble import BaggingClassifier


digit_train = pd.read_csv('/Users/piyushchoudhary/Desktop/train.csv')
digit_test = pd.read_csv('/Users/piyushchoudhary/Desktop/test.csv')

Y = digit_train['label']

X = digit_train[[column for column in digit_train.columns if column!= 'label']]
X_train, X_test, Y_train, Y_test = model_selection.train_test_split(X,Y,test_size = 0.3, random_state = 37)

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

final_model = svm.SVC(C=1,kernel='poly', gamma=1, coef0=0.1, degree=2)
final_model = svm.SVC(kernel='rbf', C=1, gamma=1e-1)


final_model.fit(X_train,Y_train)

Y_pred = final_model.predict(X=X_test)
metrics.accuracy_score(y_pred=Y_pred,y_true=Y_test)
metrics.confusion_matrix(y_pred=Y_pred,y_true=Y_test)
metrics.f1_score(y_pred=Y_pred,y_true=Y_test,average='macro')

final_model.fit(X,Y)

test_X = digit_test
test_X = np.matrix(test_X)
preds = final_model.predict(X=test_X)

d = {'ImageId':range(1, 28001), 'Label':preds}
d = pd.DataFrame(data=d)
d.to_csv('/Users/piyushchoudhary/Desktop/submission2.csv')
