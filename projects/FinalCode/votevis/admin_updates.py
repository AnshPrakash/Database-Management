from sqlalchemy import create_engine
#import pandas as pd

engine = create_engine('postgresql+psycopg2://postgres:031092lovy@localhost:5432/project1')

def insert(state,pc_name, pc_code, cand, party, votes):
    query ='''INSERT INTO ge_2019_cand_wise VALUES ('{0}','{1}',{2},'{3}','{4}',{5})'''
    engine.execute(query.format(state,pc_name, pc_code, cand, party, votes))
    
def update(state,pc_code, cand, party, votes):
    query ='''UPDATE ge_2019_cand_wise set votes={4} WHERE state='{0}' and pc_code='{1}' and
    cand='{2}' and party='{3}'
    '''
    engine.execute(query.format(state, pc_code, cand, party, votes))
    
    