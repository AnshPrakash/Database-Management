from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine,text
import select
import psycopg2
import psycopg2.extensions
import sendmail
import queries
import json

engine = create_engine('postgresql+psycopg2://postgres:postgres@localhost:5432/project1')
conn = engine.connect()
conn.execute(text("LISTEN election_updates").execution_options(autocommit=True))
print("Waiting for notifications on channels 'election_updates'")


while 1:
  if select.select([conn.connection],[],[],5) == ([],[],[]):
    print("Timeout")
  else:
    conn.connection.poll()
    while conn.connection.notifies:
      notify = conn.connection.notifies.pop()
      print("Got NOTIFY:", notify.pid, notify.channel, notify.payload)
      data = json.loads(notify.payload) 
      state = (data["state"])
      pc_name = (data["pc_name"])
      df = queries.get_users(state,pc_name)
      # print(str(notify.payload))
      for email in list(df["email"]):
        sendmail.send_mail(email,"Update of election",str(notify.payload))

      # f.write("Got NOTIFY:")
      # f.close()

