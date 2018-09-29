import time
import pandas as pd
from sklearn.manifold import TSNE

cuisine_data = pd.read_csv('/home/sambeet/data/cds assignments/processed_cuisine_data_3.csv')

time_start = time.time()
tsne = TSNE(n_components=2, verbose=1, perplexity=20, n_iter=300)
tsne_results = tsne.fit_transform(cuisine_data.iloc[:,2:len(cuisine_data.columns)].values)

print 't-SNE done! Time elapsed: {} seconds'.format(time.time()-time_start)

#https://medium.com/@luckylwk/visualising-high-dimensional-datasets-using-pca-and-t-sne-in-python-8ef87e7915b
