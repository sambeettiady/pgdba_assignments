import numpy as np
import pandas as pd

x = pd.read_csv('/Users/sambeet/Desktop/advertising.csv')
X = x[['TV','Radio','Newspaper']].values
y = np.array([[1 if sal >= 10 else 0 for sal in x.Sales]]).T

num_examples = len(X)
input_dim = 3 
output_dim = 1 
hidden_nodes = 1

def sigmoid(x):
    return 1 / (1 + np.exp(-x))
 
#Initialise Learning Rate
learning_rate = 0.01 # learning rate for gradient descent

#Calculate Binary Cross-Entropy
def calculate_loss(model):
    W1, b1, W2, b2 = model['W1'], model['b1'], model['W2'], model['b2']
    # Forward propagation to calculate our predictions
    z1 = X.dot(W1) + b1
    a1 = sigmoid(z1)
    z2 = a1.dot(W2) + b2
    prob = sigmoid(z2)
    # Calculating the loss
    logloss = -(y*np.log(prob) + (1-y)*np.log(1-prob))
    data_loss = np.sum(logloss)
    return 1./num_examples * data_loss

#Build the neural network
def build_model(num_passes=1000, random_seed = 37):
     
    #Initialize the parameters to random values
    np.random.seed(random_seed)
    W1 = np.random.randn(input_dim, hidden_nodes)
    b1 = np.zeros((1, hidden_nodes))
    W2 = np.random.randn(hidden_nodes, output_dim)
    b2 = np.zeros((1, output_dim))
 
    #Final Model Object
    model = {}
    
    # Gradient descent code
    for i in xrange(0, num_passes):

        #Forward propagation
        z1 = X.dot(W1) + b1
        a1 = sigmoid(z1)
        z2 = a1.dot(W2) + b2
        prob = sigmoid(z2)
 
        #Backpropagation
        delta3 = prob - y
        dW2 = (a1.T).dot(delta3)
        db2 = np.sum(delta3, axis=0, keepdims=True)
        delta2 = delta3.dot(W2.T) * (1 - a1) * a1
        dW1 = np.dot(X.T, delta2)
        db1 = np.sum(delta2, axis=0,keepdims=True)
 
        #Gradient descent parameter update
        W1 += -learning_rate * dW1
        b1 += -learning_rate * db1
        W2 += -learning_rate * dW2
        b2 += -learning_rate * db2
        
        # Assign new parameters to the model
        model = { 'W1': W1, 'b1': b1, 'W2': W2, 'b2': b2}
        
        if i % 50 == 0:
          print "Loss after iteration %i: %f" %(i, calculate_loss(model))
    print "Final Loss: %f" %calculate_loss(model)
    return model

#Run model 
nnet_model = build_model()
print nnet_model
