from flask import render_template, url_for, flash, redirect, send_from_directory, request,jsonify
from votevis import app, queries
#from votevis.forms import filterform
import matplotlib.pyplot as plt
import numpy as np
#import pandas as pd
import os
from votevis.forms import RegistrationForm, LoginForm
from votevis.models import User
from flask_login import login_user,current_user,logout_user,login_required

UPLOAD_FOLDER=r"/home/ansh/8thSem/COL362/projects/code/votevis/uploads"

election = 'ge_2014'
states_list = []
con_list = []
# userid = 'Kshitij'

@app.route("/", methods=['GET','POST'])
@app.route("/home", methods=['GET','POST'])
def home():
    global election
    res = queries.get_all_res(election=election)[1]
    num_electors = queries.get_num_electors(election=election).iloc[0,0]
    num_parties = queries.get_num_parties(election=election).iloc[0,0]
    total_turnout = queries.get_total_turnout(election=election).iloc[0,0]
    num_const = queries.get_num_const(election=election).iloc[0,0]
    num_cands = queries.get_num_cands(election=election).iloc[0,0]
    coms = queries.get_50_comments(page='home')
    if request.method == "POST":
        com = request.form["comment"]
        if current_user.is_authenticated:
          queries.insert_comm(current_user.id,com,'home')
        return redirect(url_for('home'))
    return render_template('home.html', election_yr=election, data=res.to_html(index=False),\
                       num_electors=num_electors,num_parties=num_parties,total_turnout=total_turnout\
                       ,num_const=num_const,num_cands=num_cands,coms=coms,length=len(coms))

        
@app.route("/register/", methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
      return redirect(url_for('home'))
    form = RegistrationForm()
    if request.method == 'POST':
      form.constituency.choices = [(x[0],x[0]) for x in  queries.get_state_consts(form.state.data).values.tolist()]
    # print(form.state.data)
    # form.constituency.choices = [ (x[0],x[0]) for x in  queries.get_state_consts(form.state.data).values.tolist()]
    if form.validate_on_submit():
        flash(f'Account created for {form.username.data}!', 'success')
        res = queries.insert_user(form.state.data,form.constituency.data,
                                  form.username.data,form.email.data,form.password.data)
        print(res)
        return redirect(url_for('home'))
    return render_template('register.html', title='Register', form=form)


@app.route("/constituency/<state>")
def constituency(state):
  constituencies = [ x[0] for x in  queries.get_state_consts(state).values.tolist()]
  i=0
  test={}
  for const in constituencies:
    test['id'+str(i)]=const
    i += 1
  return(jsonify(test))


@app.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
      return redirect(url_for('home'))
    form = LoginForm()
    if form.validate_on_submit():
        res = queries.userdata(form.email.data)
        user = User()
        user.name = res["name"].iloc[0]
        user.id = res["email"].iloc[0]
        user.password = res["password"].iloc[0]
        user.state = res["state"].iloc[0]
        user.pc_name = res["pc_name"].iloc[0]
        if not res.empty and user.password == form.password.data:
            login_user(user,remember = form.remember.data)
            flash('You have been logged in!', 'success')
            return redirect(url_for('home'))
        else:
            flash('Login Unsuccessful. Please check email or password', 'danger')
    return render_template('login.html', title='Login', form=form)

@app.route("/logout")
def logout():
  logout_user()
  return redirect(url_for('home'))


@app.route("/account")
@login_required
def account():
  return render_template('account.html',title='Account')

@app.route("/state/<st_name>")
def state(st_name):
  con_list = queries.get_state_consts(st_name).values.tolist()    
  return render_template('home_state.html', consts=con_list, states=states_list, st_name=st_name)




@app.route("/about")
def about():
    return render_template('about.html')
    
@app.route("/<election_yr>/elec_summary", methods=['GET','POST'])
def elec_summary(election_yr):
    global election
    election=election_yr
    res = queries.get_all_res(election=election_yr)[1]   
    num_electors = queries.get_num_electors(election=election_yr).iloc[0,0]
    num_parties = queries.get_num_parties(election=election_yr).iloc[0,0]
    total_turnout = queries.get_total_turnout(election=election_yr).iloc[0,0]
    num_const = queries.get_num_const(election=election_yr).iloc[0,0]
    num_cands = queries.get_num_cands(election=election_yr).iloc[0,0]
    coms = queries.get_50_comments(page='home')
    if request.method == "POST":
        com=request.form["comment"]
        if current_user.is_authenticated:
          queries.insert_comm(current_user.id,com,'home')
        return redirect(url_for('elec_summary',election_yr=election_yr))
    return render_template('home.html', election_yr=election_yr, data=res.to_html(index=False),\
                           num_electors=num_electors,num_parties=num_parties,total_turnout=total_turnout\
                           ,num_const=num_const,num_cands=num_cands,coms=coms,length=len(coms))





@app.route("/state")
def sel_state():
    global states_list
    states_list = queries.get_all_states(election).values.tolist() 
    return render_template('home_select_state.html', states=states_list, election=election)

@app.route("/state/<st_name>")
def sel_const(st_name):
    global con_list
    con_list = queries.get_state_consts(st_name, election).values.tolist()
    res = queries.get_all_res(election=election,state=st_name)[1]
    num_electors = queries.get_num_electors(election=election,state=st_name).iloc[0,0]
    num_parties = queries.get_num_parties(election=election,state=st_name).iloc[0,0]
    total_turnout = queries.get_total_turnout(election=election,state=st_name).iloc[0,0]
    num_const = queries.get_num_const(election=election,state=st_name).iloc[0,0]
    num_cands = queries.get_num_cands(election=election,state=st_name).iloc[0,0]    
    return render_template('home_select_const.html', consts=con_list, states=states_list, \
                           st_name=st_name, election=election,data=res.to_html(index=False),\
                            num_electors=num_electors,num_parties=num_parties,total_turnout=total_turnout\
                           ,num_const=num_const,num_cands=num_cands,election_yr=election)

@app.route("/const/<st_name>/<const_name>")
def const_res(st_name, const_name):
    res = queries.get_const_res(st_name,const_name,election)[['pc_name','lead_cand','lead_party',\
                               'trail_cand','trail_party','margin']]
    return render_template('home_const_res.html', const_nm=const_name, consts=con_list,\
                           tables=res.to_html(index=False), election=election, \
                           states=states_list, st_name=st_name)

@app.route('/elec_comparison')
def elec_comparison():
    legend = 'Votes_Margin'
    dataset = []
    dataset2=[]
    years = ['1998','1999','2004','2009','2014']
    cand_cont=[]
    for i in years:
        dataset.append(queries.cand_wise(i))
        dataset2.append(queries.electors(i))
        cand_cont.append(queries.total_cand(i).iloc[0,0])
    winner_party=[]
    runner_up_party=[]
    votes_margin=[]
    total_electors=[]
    polling_perc=[]
    for j in dataset:
        print(j)
        winner_party.append(j.iloc[0,0])
        runner_up_party.append(j.iloc[1,0])
        votes_margin.append(j.iloc[0,1]-j.iloc[1,1])
    for j in dataset2:
        total_electors.append(j.iloc[0,1])
        polling_perc.append(round(j.iloc[0,0]/j.iloc[0,1]*100,2))
    return render_template('plot_elec_comp.html', values=votes_margin,data1=winner_party,data2=runner_up_party,labels=years,\
                           elec=total_electors,cont=cand_cont,turnout=polling_perc,legend=legend)



@app.route("/request", methods=['GET', 'POST'])
def filters():
    if request.method == "GET":
        return render_template("filter_form.html")
    elif request.method == "POST":
        sel_filters = request.form.getlist("filters")
        return redirect(url_for('filtered_res', sel_fil=sel_filters, election_yr='ge_2014'))


@app.route("/<election_yr>/filtered/<sel_fil>")    
def filtered_res(sel_fil, election_yr):
    
    cat_dict={'total_turnout':['85_100','70_85','50_70','30_50','0_30'],'pc_type':['GEN','SC','ST'],\
              'margin':['0_5000','5000_30000','30000_150000',\
                          '150000_300000','300000_1000000'], 'total_electors':\
               ['0_1000000','1000000_1500000','1500000_2000000','2000000_4000000'] }                                   
    sel_dict={'total_turnout':[],'pc_type':[], 'margin':[], 'total_electors':[]}
    sel_fil2=sel_fil
    sel_fil=sel_fil.strip('][').split(', ')
    for i in range(len(sel_fil)):
        sel_fil[i]=sel_fil[i][1:len(sel_fil[i])-1]
        
    for key in cat_dict:
        flag=0
        for item in cat_dict[key]:
            if item in sel_fil:
                sel_dict[key].append(item)
                flag=1
        if flag==0:
#            print(key)
            for item in cat_dict[key]:
                sel_dict[key].append(item)

    res=queries.filter_master(sel_dict, election=election_yr)
    det_res=res[0]
    res=res[1]
#    print(sel_fil)
#    print(sel_dict)
    files=make_graph(det_res,res,election_yr,sel_fil)
    return render_template('filter_res.html', states=states_list, img_src=files[0],img_src1=files[1], \
                           data=det_res.to_html(index=False),sel_fil=sel_fil2,election_yr=election_yr)


@app.route('/uploads/<filename>')
def send_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)

def make_graph(det_res,res,election_yr,sel_fil):
    filename=''
    filename1=''
    if len(det_res)>0:
#        plt.pie(x=res['seat_count'], labels=res['lead_party'], autopct='%1.1f%%', shadow=True)
        plt.barh(np.arange(len(res)), res['seat_count'], align='center', alpha=0.5)
        #x=np.arange(len(res)), height=res['seat_count'], align='center', width=0.8, bottom=None)
        plt.yticks(np.arange(len(res)), res['lead_party'])
        plt.xlabel('Seats')
        plt.title('Seat distribution')

        filename=election_yr+'_'.join(sel_fil)+'.png'
        plt.savefig(os.path.join(app.config['UPLOAD_FOLDER'], filename),bbox_inches='tight')
        plt.clf()
        
        tup=tuple(det_res['pc_name'].tolist())
        if (len(tup)==1):
                    tup='(\''+str(tup[0])+'\')'
        vs_res=queries.vote_share(tup,election)
        
        plt.pie(x=vs_res['vs'], labels=vs_res['party'], autopct='%1.1f%%', shadow=True)
        plt.title('Vote share')
        filename1=election_yr+'_'.join(sel_fil)+'1.png'
        plt.savefig(os.path.join(app.config['UPLOAD_FOLDER'], filename1),bbox_inches='tight')
        plt.clf() 
    return [filename,filename1]






@app.route('/vil_ac/state')
def vil_ac_sel_state():
    states_list = queries.get_vil_ac_states().values.tolist() 
    return render_template('vil_ac_select_state.html', states=states_list)

@app.route('/vil_ac/state/<st_name>', methods=['GET', 'POST'])
def vil_ac_sel_village(st_name):    
    village_list = queries.get_vil_ac_villages(st_name).iloc[:,0].values.tolist() 
    if request.method == "GET":
        return render_template('vil_ac_select_village.html', states=states_list,st_name=st_name,\
                               villages=village_list)
    elif request.method == "POST":
        village = request.form["Village"]
        table = queries.get_vil_ac_village_info(st_name, village)
        return render_template('vil_ac_select_village.html', states=states_list,st_name=st_name,\
                               villages=village_list, vil_name=village, data=table.to_html(index=False))
    
  
    
    
@app.route('/cand/<party>', methods=['GET', 'POST'])
def cand_info_wise(party='all'):
    parties = queries.cand_party(election).iloc[:,0].values.tolist()
    foo=[]
    res = queries.cand_qual(election,party)
    foo.append(make_bar_chart(res,'qual','Candidate by Qualification',party))
    res = queries.cand_crim_case(election,party)
    foo.append(make_bar_chart(res,'crim','Candidate by Criminal Cases',party))
    res = queries.cand_gender(election,party)
    foo.append(make_bar_chart(res,'gen','Candidate by Gender',party))
    res = queries.cand_assets(election,party)
    foo.append(make_bar_chart(res,'asset','Candidate by Total Assets',party))    
    if request.method == "GET":
        return render_template('cand_wise.html', parties=parties, party=party, img_src=foo,\
                           election=election)
    
    elif request.method == "POST":
        party = request.form["Party"]
        foo=[]
        res = queries.cand_qual(election,party)
        foo.append(make_bar_chart(res,'qual','Candidate by Qualification',party))
        res = queries.cand_crim_case(election,party)
        foo.append(make_bar_chart(res,'crim','Candidate by Criminal Cases',party))
        res = queries.cand_gender(election,party)
        foo.append(make_bar_chart(res,'gen','Candidate by Gender',party))
        res = queries.cand_assets(election,party)
        foo.append(make_bar_chart(res,'asset','Candidate by Total Assets',party)) 
        return render_template('cand_wise.html', parties=parties, party=party, img_src=foo,\
                               election=election)
    
def make_bar_chart(res,col_name,tit,party):    
    plt.barh(np.arange(len(res)), res['count'], align='center', alpha=0.4)
    plt.yticks(np.arange(len(res)), res[col_name])
    plt.xlabel('Number of Candidates')
    plt.title(tit)
    filename='cand'+col_name+election+party+'.png'
    plt.savefig(os.path.join(app.config['UPLOAD_FOLDER'], filename),bbox_inches='tight')
    plt.clf()
    return filename