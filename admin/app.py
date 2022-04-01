import csv
import os
import string
from datetime import datetime
import mysql.connector
import requests
from flask import Flask, redirect, render_template, request, session, url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm.exc import *
from config import DBDetail, ADMDetail

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql://{DBDetail.user}:{DBDetail.password}@{DBDetail.host}/{DBDetail.dbname}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

if __name__ == "__main__":
    app.secret_key = os.getenv('SECRET_KEY')
#PROD Apache reference in app.wsgi

db = SQLAlchemy(app, engine_options={"pool_pre_ping":True})

class World(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    country = db.Column(db.String(50), nullable=False, unique=True)
    area = db.Column(db.Integer)
    gdp = db.Column(db.BigInteger)
    population = db.Column(db.BigInteger)
    code = db.Column(db.String(2), nullable=False)

    def __repr__(self):
        return str(self.country)

def admin_mode(f):
    def wrapper(*args, **kwargs):
        if 'admin_mode' in session:
            return f(*args, **kwargs)
        else:
            return redirect('/')
    wrapper.__name__ = f.__name__
    return wrapper

@app.route('/upload')
@admin_mode
def uploadRender():
    return render_template('upload.html')

@app.route("/upload", methods=['POST'])
@admin_mode
def uploadFiles():
    uploaded_file = request.files['file']
    uploaded_file.seek(0, os.SEEK_END)
    file_size = uploaded_file.tell()
    uploaded_file.seek(0, 0)
    cwd = os.path.dirname(__file__)
    if uploaded_file.filename != '':
        if (file_size < 200000 and (uploaded_file.filename).endswith('.csv')):
            now = datetime.now()
            file_path = os.path.join(cwd,'./uploaded',f"{now.strftime('%d%m%Y%H%M%S')}{uploaded_file.filename}")
            uploaded_file.save(file_path)
            try:
                db.create_all()
                local_csv = open(file_path)
                cr = csv.reader(local_csv)
                for row in cr:
                    db.session.add(World(country=row[0], area=row[1], gdp=row[2], population=row[3], code=row[4]))
                    db.session.commit()
                message = "Data uploaded successfully"
                return render_template('install.html', message=message, )
            except Exception as err:
                message = f"Error occured during the data upload, review a below error message:"
                return render_template('install.html', message=message, err=err)
        else:
            message = f"File extension or size not supported!"
            return render_template('install.html', message=message)
    else:
        message = f"No file provided"
        return render_template('install.html', message=message)

@app.route('/', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        if request.form['username'] != ADMDetail.user or request.form['password'] != ADMDetail.password:
            message = 'Wrong Credentials! Please try again.'
            return render_template('admin.html', message=message)
        else:
            session['admin_mode'] = True
            message = 'Success: You are now in admin mode'
            return render_template('admin.html', admin_mode=session['admin_mode'])
    else:
        admin_mode = session.get("admin_mode")
        return render_template('admin.html', admin_mode=admin_mode)

@app.route('/logout')
@admin_mode
def logout():
    session.pop('admin_mode', None)
    return redirect('/')

@app.route('/health')
def alive():
    return 'I am alive'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')


