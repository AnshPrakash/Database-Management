from sqlalchemy import create_engine
import pandas as pd

engine = create_engine('postgresql+psycopg2://postgres:031092lovy@localhost:5432/project1')


def get_all_states():
    query = '''SELECT DISTINCT(state) FROM pc_turnout
    '''
    df = pd.read_sql_query(query.format(), engine)
    return df

def get_state_consts(state):
    query = '''SELECT DISTINCT(lower(pc_name)) FROM pc_turnout
    WHERE state='{0}'
    '''
    df = pd.read_sql_query(query.format(state), engine)
    return df

def get_const_res(state,const):
    #not efficient
    query = '''SELECT * FROM pc_res
    WHERE state='{0}' AND lower(pc_name)=lower('{1}')
    '''
    df = pd.read_sql_query(query.format(state,const), engine)
    return df

def filt_by_turnout(l,u):
    query = '''SELECT pc_res.pc_name,lead_cand,lead_party,trail_cand,trail_party,margin 
    FROM pc_res, pc_turnout WHERE pc_res.pc_code=
    pc_turnout.pc_code AND pc_res.state= pc_turnout.state
    AND total_turnout between {0} AND {1} ORDER BY pc_name 
    '''
    df_det = pd.read_sql_query(query.format(l,u), engine)
    df_new = get_top_4_parties(df_det)
    return [df_det,df_new]


def filter_master(sel_dict):
    query = make_master_query(sel_dict)
    df_det = pd.read_sql_query(query, engine)
    df_new = get_top_4_parties(df_det)
    return [df_det,df_new]



def get_top_4_parties(df_det):
    df = df_det.groupby('lead_party').pc_name.count().reset_index()
    df.columns=['lead_party','seat_percent']
    if(len(df)>4):
        df_new = df.loc[:4,:].copy()
        other_seat = df.loc[4:].seat_percent.sum()
        df_new.loc[4] = ['Others', other_seat]
    else:
        df_new=df
    return df_new 


def make_master_query(sel_dict):
    query = ''' SELECT pc_res.pc_name,lead_cand,lead_party,trail_cand,trail_party,margin FROM pc_res INNER JOIN
        (SELECT state, pc_code, ((cast(female_electors as decimal(10,2)))/male_electors) AS gen_ratio FROM pc_turnout) pc_turnout1, 
        (SELECT DISTINCT(state, pc_code, pc_type as category) FROM pc_info) pc_info1 
        WHERE pc_res.pc_code=pc_turnout1.pc_code AND pc_res.state= pc_turnout1.state AND pc_res.pc_code=
        pc_info1.pc_code AND pc_res.state=pc_info1.state 
        
    '''
    #    if len(sel_dict['turnout'])>0:
    
    type_dict={'total_turnout':'num','category':'cat','gen_ratio':'num'}
    
    for key in sel_dict:
        if len(sel_dict[key])>0:
            if type_dict[key]=='num':
                query += ''' AND (true'''
                for item in sel_dict[key]:
                    l = float(item.split('_')[0])
                    u = float(item.split('_')[1])
                    query += ''' OR ({0} BETWEEN {1} AND {2}) '''.format(key,l,u)
                query += ''') '''   
            else:
                query += '''AND '''+key+''' in {0}'''.format(tuple(sel_dict[key]))
    print (query)
    return query       
    
    
    
    