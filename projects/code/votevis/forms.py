from flask import Flask, render_template
from flask_wtf import FlaskForm
from flask.ext.wtf import Form, widgets, SelectMultipleField, SubmitField

class filterform(FlaskForm):
    