import pandas as pd
df=pd.read_csv("data.csv")
df=df.loc[:,:14]
df.to_csv('dataset.csv')