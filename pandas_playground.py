import pandas as pd
import random as rd
import os

os.chdir('/Users/sambeet/Desktop/')

#Series
rd.seed(20)
L = [rd.randint(0,100) for i in range(0,200)]
type(L)
print L

SeriesL = pd.Series(L)
type(SeriesL)
print SeriesL

SeriesL.describe()
#Define function
def add_20(x):
    return x + 20
SeriesL = SeriesL.apply(add_20)
SeriesL.value_counts()

#Dataframe
df = pd.DataFrame(SeriesL)
print df
df.shape

#Reading data
inference_data = pd.read_csv('effort_data.csv')
#index
#wide and long format

#Check dimensions and first few rows
inference_data.shape
inference_data.head()
inference_data.tail()

#Rename
inference_data.columns = [name.lower().replace(' ','_') for name in inference_data.columns]
inference_data.columns = ['process_type','complexity','effort','service_domain']

#Creating new columns/variables:
#This doesnt work 
inference_data.new_effort = inference_data.effort + 1 
inference_data.shape
#Works!!!
inference_data['new_effort'] = inference_data.effort + 1
inference_data.shape

#Copy
new_df = inference_data
#Default is Axis = 0 meaning rows
new_df.drop(['new_effort'],axis=1)
new_df.drop(0,axis=0)
new_df.drop(['new_effort'],axis=1,inplace=True)

new_df = inference_data.copy()
new_df['new_effort'] = new_df.effort + 1

#Selecting columns and filtering rows
new_df = new_df[['process_type','complexity','effort','service_domain']]
new_df = new_df[new_df.effort < 50]
new_df = new_df[new_df.effort < 50][['complexity','effort','service_domain']]

#Label based selection
new_df = new_df.loc[new_df.effort < 50,['effort','complexity']]
new_df = new_df.loc[0:10,['effort','complexity']]
#Selection based on integer position
new_df = new_df.iloc[0:5,1:2]
new_df.index
new_df.reset_index() #Doesnt work
new_df = new_df.reset_index()
new_df.reset_index(inplace=True)
new_df.drop(['index'],axis=1,inplace=True)

new_df = inference_data.copy()
new_df['new_effort'] = new_df.effort + 1
new_df['ekdum_new_effort'] = new_df.effort + 100

#Summary Stats:
inference_data.describe()
inference_data.describe(include='all')

#Grouped summary stats:
inference_data.groupby(['complexity']).describe()
inference_data.groupby(['complexity','service_domain']).describe()
description = inference_data.groupby(['complexity','service_domain']).describe()
description.to_csv('descriptive_stats.csv') #index=True default

#Plotting:
#Histogram
inference_data.effort.hist()
inference_data.hist(column='effort')
inference_data.hist(by='complexity',column='effort')
inference_data.hist(by=['complexity','service_domain'],column='effort')
inference_data.hist(by=['complexity','service_domain','process_type'],
column='effort',figsize=[100,80],layout=[6,3],xlabelsize=50,ylabelsize=50)

#Boxplot
inference_data.boxplot()
new_df.boxplot()

#Scatterplot
new_df.plot()
new_df.plot(kind='scatter',x='effort',y='new_effort')

#Multiple Scatterplots
ax = new_df.plot(kind='scatter',x='effort',y='new_effort',color='blue',label='New Effort')
new_df.plot(kind='scatter',x='effort',y='ekdum_new_effort',color='red',label='Ekdum New Effort',ax=ax)

#Line graph
new_df.plot(kind='line',x='effort',y=['new_effort','ekdum_new_effort'],title='Title')
