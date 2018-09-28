import sklearn as sk
import pandas as pd
import numpy as np
import os

os.chdir('/Users/sambeet/Downloads/')

url_to_get = 'http://www.souravsengupta.com/cds2017/evaluation/cuisine.json'
cuisine_data = pd.read_json(url_to_get)
cuisine_data.head()

unique_ingredients = []
for row in cuisine_data.ingredients:
    for ingredient in row:
        unique_ingredients.append(ingredient.lower())

unique_ingredients = list(set(unique_ingredients))

output_binary = lambda x: 1 if ingredient in x else 0
final_df = pd.DataFrame()
final_df['dish_id'] = cuisine_data['id']
for ingredient in unique_ingredients:
    print ingredient
    final_df[ingredient] = cuisine_data.ingredients.apply(output_binary)

final_df.columns = [column_name.encode('utf-8','ignore') for column_name in final_df.columns]
final_df.to_csv('processed_cuisine_data_2.csv',index=False)
