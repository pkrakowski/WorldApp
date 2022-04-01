import csv
import json
import os
import string
import urllib.request
from functools import wraps
import requests
from flask import (Flask, make_response, redirect, render_template, request,
                   session, url_for)

api_url= os.getenv('API_URL')
static_host = os.getenv('STATIC_HOST')

app = Flask(__name__)
dirname = os.path.dirname(__file__)
letters = string.ascii_uppercase

@app.route('/', methods=['GET','POST'])
def index():
    result = ""
    #Check if API has connection to the DB
    try:
        country_list = requests.get(f"{api_url}/all")
        if country_list.status_code == 200:
            country_list = country_list.json().values()

        if (request.method == 'POST' and request.form['search_query'] != ''):
            search_query = request.form['search_query']
            result = requests.get(f"{api_url}/{search_query}")
            if (result.status_code == 200) and (result.json()['data']['code']) != 404:
                result = result.json()['data']
                return render_template('result.html', result=result, static_host=static_host)
            else:
                result = result.json()['data']['message']
                return render_template('index.html', country_list=country_list, letters=letters, static_host=static_host, result=result)

        return render_template('index.html', country_list=country_list, letters=letters, static_host=static_host, result=result)
    except:
        result = 'Something went wrong with connection to the API'
        return render_template('index.html', static_host=static_host, result=result)

@app.route('/health')
def alive():
    return 'I am alive'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')


