from votevis import login_manager, queries
from flask_login import UserMixin

@login_manager.user_loader
def load_user(user_id):
  user = User()
  df = queries.userdata(user_id)
  if not df.empty:
    user.name = df["name"].iloc[0]
    user.id = df["email"].iloc[0]
    user.password = df["password"].iloc[0]
    user.state = df["state"].iloc[0]
    user.constituency = df["pc_name"].iloc[0]
  return(user)



class User(UserMixin):
  name = ""
  id = ""
  password = ""
  state = ""
  constituency = ""
  
  def __repr__(self):
    return f"User('{self.name}', '{self.id}','{self.password}','{self.state}','{self.constituency}')"

