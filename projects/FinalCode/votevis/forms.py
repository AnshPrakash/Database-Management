from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, BooleanField,SelectField
from wtforms.validators import DataRequired, Length, Email, EqualTo,ValidationError
from votevis import queries
from votevis.models import User


class RegistrationForm(FlaskForm):
  username = StringField('Username',
               validators=[DataRequired(), Length(min=2, max=20)])
  email = StringField('Email',
            validators=[DataRequired(), Email()])
  # l = queries.get_all_states('ge_2014').values.tolist()
  # print(l)
  state = SelectField('state',choices = [(statev[0],statev[0]) for statev in queries.get_all_states('ge_2014').values.tolist()])
  constituency = SelectField('constituency',choices = [])
  password = PasswordField('Password', validators=[DataRequired()])
  confirm_password = PasswordField('Confirm Password',
                   validators=[DataRequired(), EqualTo('password')])
  submit = SubmitField('Sign Up')

  def validate_email(self,email):
    # print(email)
    res = queries.userdata(email.data)
    # print("yo",res.empty)
    if not (res.empty):
      raise  ValidationError('User already exists')


class LoginForm(FlaskForm):
  email = StringField('Email',
            validators=[DataRequired(), Email()])
  password = PasswordField('Password', validators=[DataRequired()])
  remember = BooleanField('Remember Me')
  submit = SubmitField('Login')