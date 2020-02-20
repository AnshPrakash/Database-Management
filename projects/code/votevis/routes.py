from flask import render_template, url_for, flash, redirect, send_from_directory, request
from votevis import app, queries
#from votevis.forms import filterform
import matplotlib.pyplot as plt
import pandas as pd
import os

UPLOAD_FOLDER=r"D:/Padhai/Sem8/COL362/project1/votevis/uploads"
states_list = queries.get_all_states().values.tolist()    
#my_path = os.path.abspath(__file__)

@app.route("/")
@app.route("/home")
def home():  
    return render_template('home.html', states=states_list)


@app.route("/state/<st_name>")
def state(st_name):
    con_list = queries.get_state_consts(st_name).values.tolist()    
    return render_template('home_state.html', consts=con_list, states=states_list, st_name=st_name)

@app.route("/const/<st_name>/<const_name>")
def const(st_name, const_name):
    res = queries.get_const_res(st_name,const_name)[['pc_name','lead_cand','lead_party',\
                               'trail_cand','trail_party','margin']]
    return render_template('home_const.html', consts=const_name,\
                           tables=[res.to_html(classes='data')], titles=res.columns.values,\
                           states=states_list, st_name=st_name)
    
@app.route("/filter/turnout/<turn_out>")
def filter_cat(turn_out):
    res=pd.DataFrame([])
    if(turn_out=='85_'):
        res=queries.filt_by_turnout(85,100)
    elif(turn_out=='70_85'):
        res=queries.filt_by_turnout(70,85)
    elif(turn_out=='50_70'):
        res=queries.filt_by_turnout(50,70)
    elif(turn_out=='30_50'):
        res=queries.filt_by_turnout(30,50)
    elif(turn_out=='_30'):
        res=queries.filt_by_turnout(0,30)
    else:
        return redirect('\home')
    
    det_res=res[0]
    res=res[1]
    plt.pie(x=res['seat_percent'], labels=res['lead_party'], autopct='%1.1f%%', shadow=True)
    print(res['lead_party'])
    filename='turnout'+turn_out+'.png'
    plt.savefig(os.path.join(app.config['UPLOAD_FOLDER'], filename),bbox_inches='tight')
    plt.clf()
    return render_template('filter_res.html', states=states_list, img_src=filename,\
                           data=det_res.to_html())


@app.route("/request", methods=['GET', 'POST'])
def filters():
    if request.method == "GET":
        return render_template("form_try.html")
    elif request.method == "POST":
        sel_filters = request.form.getlist("filters")
        return redirect(url_for('filtered_res', sel_fil=sel_filters))



@app.route("/filtered/<sel_fil>")    
def filtered_res(sel_fil):
    print(sel_fil)
    cat_dict={'total_turnout':['85_100','70_85','50_70','30_50','0_30'],'category':['GEN','SC','ST'],\
              'gen_ratio':['1.0_2.0','0.9_1.0','0_0.9']}
    sel_dict={'total_turnout':[],'category':[],\
              'gen_ratio':[]}
    for key in cat_dict:
        flag=0
        for item in cat_dict[key]:
            if item in sel_fil:
                sel_dict[key].append(item)
                flag=1
        if flag==0:
            for item in cat_dict[key]:
                sel_dict[key].append(item)
    
    res=queries.filter_master(sel_dict)
    det_res=res[0]
    res=res[1]
    plt.pie(x=res['seat_percent'], labels=res['lead_party'], autopct='%1.1f%%', shadow=True)
    print(res['lead_party'])
    filename='_'.join(sel_fil)+'.png'
    plt.savefig(os.path.join(app.config['UPLOAD_FOLDER'], filename),bbox_inches='tight')
    plt.clf()
    return render_template('filter_res.html', states=states_list, img_src=filename,\
                           data=det_res.to_html())

   
    
@app.route('/uploads/<filename>')
def send_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)

