from flask import Flask
#from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
#app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
#app.config['SECRET_KEY'] = '5791628bb0b13ce0c676dfde280ba245'
#app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://localhost/project1'
#db = SQLAlchemy(app)
UPLOAD_FOLDER = r"D:/Padhai/Sem8/COL362/project1/votevis/uploads"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

from votevis import routes