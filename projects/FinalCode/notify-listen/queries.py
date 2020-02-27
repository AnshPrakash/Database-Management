from sqlalchemy import create_engine
import pandas as pd

engine = create_engine('postgresql+psycopg2://postgres:postgres@localhost:5432/project1')

def get_users(state,pc_name):
  query = ''' SELECT name,email,state,pc_name FROM users WHERE lower(state) = lower('{0}') and lower(pc_name) = lower('{1}')
  '''
  df = pd.read_sql_query(query.format(state,pc_name),engine)
  return(df)
