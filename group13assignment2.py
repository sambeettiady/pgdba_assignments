import numpy as np
import pandas as pd
from sklearn import preprocessing

input_data = pd.read_csv('/home/sambeet/data/Advertising.csv',index_col='Unnamed: 0')
X = np.array(input_data[[col for col in input_data.columns if col != 'Sales']])
Y = np.array(input_data[['Sales']])
# = preprocessing.scale(X)

def BatchGradientDescent(initial_weight_vector = [1e-5,1e-5,1e-5,1e-5],X = X, Y = Y, learning_rate = 1e-10, tolerance = 1e-5):
    print initial_weight_vector
    num_obs = X.shape[0]
    num_features = X.shape[1] + 1
    X0 = np.ones((num_obs,1))
    X = np.concatenate((X,X0),axis = 1)
    X_reshaped = X.transpose()
    Y_reshaped = Y.transpose()
    weight_vector = np.matrix(np.array(initial_weight_vector).transpose())
    fitted_values = np.dot(weight_vector,X_reshaped)
    tss = np.mean(np.square(Y_reshaped - np.mean(Y_reshaped)))
    print tss
    rss1 = np.mean(np.square(Y_reshaped - fitted_values))
    print rss1
    print abs(tss - rss1)/tss
    rss0 = 0.
    rel_error = abs(rss1 - rss0)/rss1
    print rss1
    while(rel_error >= tolerance):
        rss0 = rss1
        gradient_vector = learning_rate*(1/float(num_obs))*np.dot(fitted_values - Y_reshaped,X)
        weight_vector = weight_vector - gradient_vector
        fitted_values = np.dot(weight_vector,X_reshaped)
        rss1 = np.mean(np.square(Y_reshaped - fitted_values))
        rel_error = abs(rss1 - rss0)/rss1
        print rss1
    r_squared = abs(tss - rss1)/tss
    print weight_vector, r_squared

def StochasticGradientDescent(initial_weight_vector = [1e-5,1e-5,1e-5,1e-5],X = X, Y = Y, learning_rate = 1e-10, tolerance = 1e-5):
    print initial_weight_vector
    num_obs = X.shape[0]
    num_features = X.shape[1] + 1
    X0 = np.ones((num_obs,1))
    X = np.concatenate((X,X0),axis = 1)
    X_reshaped = X.transpose()
    Y_reshaped = Y.transpose()
    weight_vector = np.matrix(np.array(initial_weight_vector).transpose())
    fitted_values = np.dot(weight_vector,X_reshaped)
    tss = np.mean(np.square(Y_reshaped - np.mean(Y_reshaped)))
    print tss
    rss1 = np.mean(np.square(Y_reshaped - fitted_values))
    print rss1
    print abs(tss - rss1)/tss
    rss0 = 0.
    rel_error = abs(rss1 - rss0)/rss1
    print rss1
    while(rel_error >= tolerance):
        rss0 = rss1
        obs_to_train = np.arange(num_obs)
        np.random.shuffle(obs_to_train)
        for obs in obs_to_train:
            gradient_vector = learning_rate*np.dot(fitted_values[:,obs] - Y_reshaped[:,obs:(obs + 1)],X[obs:(obs+1),:])
            weight_vector = weight_vector - gradient_vector
            fitted_values = np.dot(weight_vector,X_reshaped)
            rss1 = np.mean(np.square(Y_reshaped - fitted_values))
            rel_error = abs(rss1 - rss0)/rss1
            print rss1
            if(rel_error < tolerance):
                break
    r_squared = abs(tss - rss1)/tss
    print weight_vector, r_squared

BatchGradientDescent(learning_rate=1e-5,tolerance=1e-7)
StochasticGradientDescent(learning_rate=1e-6,tolerance=1e-7)
