import uuid
import os
import requests
from flask import Flask, render_template, session, request, redirect, url_for
import msal
import csv
import string
from datetime import datetime
from functools import wraps
import mysql.connector
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm.exc import *
from config import DBDetail, B2CDetail

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

@app.route("/")
def index():
    if not session.get("user"):
        return redirect(f"/admin/login")
    return render_template('admin.html',session=session)


@app.route("/login")
def login():
    session["flow"] = _build_auth_code_flow(scopes=B2CDetail.SCOPE)
    return redirect (session["flow"]["auth_uri"])

@app.route("/getToken")
def authorized():
    try:
        result = _build_msal_app().acquire_token_by_auth_code_flow(
            session.get("flow", {}), request.args)
        session["user"] = result.get("id_token_claims")
        if "error" in result:
            return render_template("auth_error.html", result=result)
        if result.get("id_token_claims")["sub"] in B2CDetail.admin_users:
            session['admin_mode'] = True
            return render_template('admin.html', session=session)
    except ValueError:
        pass
    return redirect("/admin/")

@app.route("/logout")
def logout():
    session.clear()
    return redirect(
        B2CDetail.AUTHORITY + "/oauth2/v2.0/logout" +
        f"?post_logout_redirect_uri={B2CDetail.redirect_url}")

def _build_msal_app(authority=None):
    return msal.ConfidentialClientApplication(
        B2CDetail.CLIENT_ID, authority=authority or B2CDetail.AUTHORITY,
        client_credential=B2CDetail.CLIENT_SECRET)

def _build_auth_code_flow(authority=None, scopes=None):
    return _build_msal_app(authority=authority).initiate_auth_code_flow(
        scopes or [],
        redirect_uri=B2CDetail.redirect_url)

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')



