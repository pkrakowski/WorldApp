import os
import string
import mysql.connector
import requests
from flask import Flask, jsonify, make_response, redirect, request, session
from flask_caching import Cache
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm.exc import *
from config import DBDetail

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql://{DBDetail.user}:{DBDetail.password}@{DBDetail.host}/{DBDetail.dbname}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['CACHE_TYPE'] = os.getenv('CACHE_TYPE')
app.config['CACHE_REDIS_URL'] = os.getenv('CACHE_REDIS_URL')

db = SQLAlchemy(app, engine_options={"pool_pre_ping":True})
cache = Cache(app)

class World(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    country = db.Column(db.String(50), nullable=False, unique=True)
    area = db.Column(db.Integer)
    gdp = db.Column(db.BigInteger)
    population = db.Column(db.BigInteger)
    code = db.Column(db.String(2), nullable=False)

    def __repr__(self):
        return str(self.country)

def Countries():
    countries = World.query.with_entities(World.country).all()
    country_unpacked = [value for (value,) in countries]
    return country_unpacked

@app.route('/<search_query>')
@cache.cached(timeout=10)
def api(search_query):
    try:
        if (search_query in Countries()):
            result = World.query.filter_by(country=f'{search_query}').one()
            data = {
                "country": result.country,
                "population": result.population,
                "gdp": result.gdp,
                "area": result.area,
                "code": result.code
                }
            return jsonify(data=data)
        else:
            data = {
                "code": 404,
                "message": "Country not found"
                }
            return jsonify(data=data)
    except Exception as err:
        if 'SELECT' in str(err):
            data = {
                    "code": 404,
                    "message": f"Database connection successful but table {DBDetail.dbname} doesnt exist"
                    }
            return jsonify(data=data)
        else:
            error = {
                    "code": 500,
                    "message": 'Failed connecting to the database'
                    }
            return jsonify(error=error)

@app.route('/all')
@cache.cached(timeout=10)
def all():
    try:
        data = {
                "countries": Countries()
                }
        return jsonify(data=data["countries"])
    except Exception as err:
        if 'SELECT' in str(err):
            data = {
                    "code": 404,
                    "message": f"Database connection successful but table {DBDetail.dbname} doesnt exist"
                    }
            return jsonify(data=data)
        else:
            error = {
                    "code": 500,
                    "message": 'Failed connecting to the database'
                    }
            return jsonify(error=error)

@app.route('/health')
def alive():
    return 'I am alive'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')


