from sqlalchemy import create_engine
import pandas as pd

engine = create_engine('postgresql+psycopg2://postgres:postgres@localhost:5432/project1')
# engine = create_engine('postgresql+psycopg2://group_12:872-725-884@10.17.50.126:5432/group_12')

def userdata(email):
    query = '''select * from users where email = '{0}'
    '''
    # print(query.format(email))
    df = pd.read_sql_query(query.format(email), engine)
    return(df)

def insert_user(state,const,name,email,password):
    query = '''insert into users values('{0}','{1}','{2}','{3}','{4}')
    '''
    return(engine.execute(query.format(name,email,password,state,const)))



def get_all_res(election, state=''):
    query = ''' SELECT pc_name,lead_cand,lead_party,trail_cand,trail_party,margin 
        FROM {0}'''.format(election+'_res')
    if state!='':
        query += ''' WHERE lower(state)=lower('{0}')  '''.format(state)
    df_det = pd.read_sql_query(query, engine)
    df_new = get_top_4_parties(df_det)
    return [df_det,df_new]

def get_num_electors(election, state=''):
    query = '''SELECT SUM(total_electors) FROM {0}'''.format(election+'_electors')
    if state!='':
        query += ''' WHERE lower(state)=lower('{0}')  '''.format(state)
    df = pd.read_sql_query(query, engine)
    return df

def get_num_parties(election, state=''):
    query = '''SELECT COUNT(DISTINCT party)-1 FROM {0}'''.format(election+'_cand_wise')
    if state!='':
        query += ''' WHERE lower(state)=lower('{0}')  '''.format(state)
    df = pd.read_sql_query(query, engine)
    return df

def get_total_turnout(election, state=''):
    query = '''SELECT round(cast(SUM(total_voters) as decimal)*100/SUM(total_electors),2) 
    FROM {0}'''.format(election+'_electors')
    if state!='':
        query += ''' WHERE lower(state)=lower('{0}')  '''.format(state)
    df = pd.read_sql_query(query, engine)
    return df

def get_num_const(election, state=''):
    query = '''SELECT COUNT(*) FROM {0}'''.format(election+'_res')
    if state!='':
        query += ''' WHERE lower(state)=lower('{0}')  '''.format(state)
    df = pd.read_sql_query(query, engine)
    return df 

def get_num_cands(election, state=''):
    query = '''SELECT COUNT(*) FROM {0}'''.format(election+'_cand_wise')
    if state!='':
        query += ''' WHERE lower(state)=lower('{0}')  '''.format(state)
    df = pd.read_sql_query(query, engine)
    return df 
def cand_wise(election):
    query = '''SELECT party,sum(votes) FROM {0} GROUP BY party ORDER BY sum(votes) DESC limit 2'''
    c=pd.read_sql_query(query.format('ge_'+election+'_cand_wise'), engine)
    return c
def total_cand(election):
    query = '''SELECT count(cand) FROM {0}'''
    c=pd.read_sql_query(query.format('ge_'+election+'_cand_wise'), engine)
    return c

def electors(election):
    query = '''SELECT sum(total_voters),sum(total_electors) FROM {0}'''
    c=pd.read_sql_query(query.format('ge_'+election+'_electors'), engine)
    return c

def get_all_states(election = 'ge_2014'):
    query = '''SELECT DISTINCT(state) FROM {0}
    '''
    df = pd.read_sql_query(query.format(election+'_res'), engine)
    return df

def get_state_consts(state,election = 'ge_2014'):
    query = '''SELECT DISTINCT(lower(pc_name)) FROM {1}
    WHERE state='{0}'
    '''
    df = pd.read_sql_query(query.format(state,election+'_res'), engine)
    return df

def get_const_res(state,const,election):
    #not efficient
    query = '''SELECT * FROM {2}
    WHERE state='{0}' AND lower(pc_name)=lower('{1}')
    '''
    df = pd.read_sql_query(query.format(state,const,election+'_res'), engine)
    return df


def get_vil_ac_states():
    query = '''SELECT DISTINCT(state) FROM vil_ac'''
    df = pd.read_sql_query(query, engine)
    return df

def get_vil_ac_villages(st_name):
    query = '''SELECT DISTINCT(village) FROM vil_ac WHERE state='{0}'
    '''
    df = pd.read_sql_query(query.format(st_name), engine)
    return df

def get_vil_ac_village_info(st_name, village):
    query = '''SELECT vil_ac.state,district,tahsil,vil_ac.ac_code,vil_ac.ac_name,pc_code,pc_name
    FROM vil_ac left join pc_info_2014 ON pc_info_2014.ac_code=vil_ac.ac_code AND 
    lower(pc_info_2014.ac_name)=lower(vil_ac.ac_name) WHERE vil_ac.state='{0}' AND village='{1}'
    '''
    df = pd.read_sql_query(query.format(st_name,village), engine)
    return df

def vote_share(res, election):
    df=[]    
    query='''SELECT party ,SUM(votes) as vs
    FROM {1}
    WHERE pc_name in {0}
    GROUP BY party
    ORDER BY SUM(votes) DESC'''
    df=pd.read_sql_query(query.format(res,election+'_cand_wise'), engine)
        
    if len(df)>4:
        df_new = df.loc[:4,:].copy()
        other_seat = df.loc[4:].vs.sum()
        df_new.loc[4] = ['Others', other_seat]
    else:
        df_new=df
    return df_new
    
def filter_master(sel_dict, election):
    query = make_master_query(sel_dict, election)
    df_det = pd.read_sql_query(query, engine)
    df_new = get_top_4_parties(df_det)
    return [df_det,df_new]



def get_top_4_parties(df_det):
    df = df_det.groupby('lead_party').pc_name.count().reset_index()
    df.columns=['lead_party','seat_count']
    df.sort_values('seat_count',ascending=False,inplace=True)
    df=df.reset_index(drop=True)
    if(len(df)>4):
        df_new = df.loc[:4,:].copy()
        other_seat = df.loc[4:].seat_count.sum()
        df_new.loc[4] = ['Others', other_seat]
    else:
        df_new=df
#    print(df_new)
    return df_new 


def make_master_query(sel_dict, election):
    if election =='ge_2014':
        query = ''' SELECT pc_res.pc_name,lead_cand,lead_party,trail_cand,trail_party,margin 
        FROM {0} as pc_res,
            (SELECT state, pc_code, total_electors, ((cast(female_electors as decimal(10,2)))/male_electors) 
            AS gen_ratio, total_turnout FROM {1}) pc_turnout1, 
            (SELECT DISTINCT state, pc_code, pc_type FROM pc_info_2014) pc_info1
            WHERE pc_res.pc_code=pc_turnout1.pc_code AND lower(pc_res.state)= lower(pc_turnout1.state)
            AND pc_res.pc_code= pc_info1.pc_code AND lower(pc_res.state)=lower(pc_info1.state)
        '''.format(election+'_res', election+'_electors')
    else:
        query = ''' SELECT pc_res.pc_name,lead_cand, pc_res.pc_type, lead_party,trail_cand,
        trail_party,margin FROM {0} as pc_res,
            (SELECT state, pc_code, total_electors, total_turnout FROM {1}) pc_turnout1
            WHERE pc_res.pc_code=pc_turnout1.pc_code AND lower(pc_res.state)= lower(pc_turnout1.state)
            '''.format(election+'_res', election+'_electors')
        
    type_dict={'total_turnout':'num','pc_type':'cat','gen_ratio':'num', 'margin':'num', 'total_electors':\
               'num'}#, 'crim_case':'num', 'gender':'cat'}
    
    for key in sel_dict:
        if len(sel_dict[key])>0:
            if type_dict[key]=='num':
                query += ''' AND (false'''
                for item in sel_dict[key]:
                    l = float(item.split('_')[0])
                    u = float(item.split('_')[1])
                    query += ''' OR ({0} BETWEEN {1} AND {2}) '''.format(key,l,u)
                query += ''') '''   
            else:
                temp = tuple(sel_dict[key])
                if (len(temp)==1):
                    temp='(\''+str(temp[0])+'\')'
                query += '''AND '''+key+''' in {0}'''.format(temp)
#    print(query)
    return query       

def cand_party(election):
    year = election[3:]
    query= '''SELECT DISTINCT(party) FROM affidavits_view WHERE year={0}'''.format(year)
    df = pd.read_sql_query(query, engine)
    return df
    
def cand_qual(election, party=''):
    year = election[3:]
#    DISTINCT state, pc_name, cand, crim_case, qual, tot_asset, age, party, year, gender
    query='''SELECT qual, COUNT(*) AS count FROM (SELECT CASE
            WHEN educ = 'Illiterate'::text THEN 'Illiterate'::text
            WHEN educ = ANY (ARRAY['5th Pass'::text, '12th Pass'::text, '10th Pass'::text, 'Literate'::text, '8th Pass'::text]) THEN 'School-education'::text
            WHEN educ = ANY (ARRAY['Post Graduate'::text, 'Doctorate'::text, 'Graduate Professional'::text, 'Graduate'::text]) THEN 'Higher-education'::text
            ELSE 'Unknown'  END AS qual FROM affidavits_view WHERE year={0}
            '''.format(year)
    if party!='all':
        query += ''' AND lower(party)=lower('{0}')  '''.format(party)
    query+= ''') temp GROUP BY qual'''
    df = pd.read_sql_query(query, engine)
    return df
    
def cand_crim_case(election, party=''):
    year = election[3:]
    query='''SELECT crim, COUNT(*) AS count FROM (SELECT CASE
            WHEN crim_case =0 then 'No case'
            WHEN crim_case between 1 and 3 then '1-3 cases'
            WHEN crim_case between 3 and 8 then '3-8 cases'
            WHEN crim_case>8 then 'More than 8 cases'
            ELSE 'Unknown'  END AS crim FROM affidavits_view WHERE year={0}
            '''.format(year)
    if party!='all':
        query += ''' AND lower(party)=lower('{0}')  '''.format(party)
    query+= ''') temp GROUP BY crim'''
    df = pd.read_sql_query(query, engine)
    return df    

def cand_gender(election, party=''):
    year = election[3:]
    query='''SELECT gen, COUNT(*) AS count FROM (SELECT CASE
            WHEN gender = 0 then 'Men'
            ELSE 'Women'  END AS gen FROM affidavits_view WHERE year={0}
            '''.format(year)
    if party!='all':
        query += ''' AND lower(party)=lower('{0}')  '''.format(party)
    query+= ''') temp GROUP BY gen'''
    df = pd.read_sql_query(query, engine)
    return df

def cand_assets(election, party=''):
    year = election[3:]
    query='''SELECT asset, COUNT(*) AS count FROM (SELECT CASE
            WHEN tot_asset = 100000 then 'Less than 1 lakh'
            WHEN tot_asset between 100001 and 1000000 then '1-10 lakh'
            WHEN tot_asset between 1000000 and 10000000 then '10 lakh-1 crore'
            WHEN tot_asset between 10000001 and 200000000 then '1-20 crores'
            WHEN tot_asset between 200000001 and 1000000000 then '20-100 crores'
            WHEN tot_asset>1000000000 then 'More than 100 crores'
            ELSE 'Unknown'  END AS asset FROM affidavits_view WHERE year={0}
            '''.format(year)
    if party!='all':
        query += ''' AND lower(party)=lower('{0}')  '''.format(party)
    query+= ''') temp GROUP BY asset'''
    df = pd.read_sql_query(query, engine)
    return df

def insert_comm(userid,com,page='home'):
    query = '''INSERT INTO comments (userid,page,body) VALUES ('{0}','{1}','{2}')
    '''
    engine.execute(query.format(userid,page,com))

def get_50_comments(page='home'):
    query='''SELECT userid, to_char(time, 'yyyy-MM-dd HH24:MI'), body 
    FROM comments WHERE page='{0}' ORDER BY time DESC
    LIMIT 50
    '''
    df = pd.read_sql_query(query.format(page), engine)
    return df
    
    
    